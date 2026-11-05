import { readFileSync, writeFileSync } from 'node:fs';
import { resolve } from 'node:path';
import { spawnSync } from 'node:child_process';
import { pathToFileURL } from 'node:url';

interface FlakeInput {
  url?: string;
  inputs?: Record<string, FlakeInput>;
  flake?: boolean;
  follows?: string;
  [attribute: string]: unknown;
}

interface ReferenceMetadata {
  rev?: string;
  revCount?: number;
  narHash?: string;
  lastModified?: number;
  ref?: string;
  dir?: string;
  [attribute: string]: unknown;
}

interface GitReference extends ReferenceMetadata {
  type: 'git';
  url: string;
}

interface GitHubReference extends ReferenceMetadata {
  type: 'github';
  owner: string;
  repo: string;
}

interface OtherReference extends ReferenceMetadata {
  type: 'indirect' | 'path' | 'tarball' | 'file' | 'mercurial' | 'gitlab' | 'sourcehut';
}

type FlakeReference = GitReference | GitHubReference | OtherReference;

interface LockNode {
  original?: FlakeReference;
  locked?: FlakeReference;
  inputs?: Record<string, string | string[]>;
  flake?: boolean;
}

interface FlakeLock {
  nodes: Record<string, LockNode>;
  root: string;
  version: number;
}

interface GitHubRepository {
  parsed: URL;
  owner: string;
  repo: string;
}

function githubRepository(url: string): GitHubRepository {
  const parsed = new URL(url);
  const parts = parsed.pathname.replace(/\.git$/, '').split('/').filter(Boolean);
  if (!['git+https:', 'https:'].includes(parsed.protocol) ||
      parsed.host !== 'github.com' || parsed.username || parsed.password ||
      parsed.hash || parts.length !== 2) {
    throw new Error(`Unsupported GitHub Git URL: ${url}`);
  }
  return { parsed, owner: parts[0], repo: parts[1] };
}

export function snapshotUrl(url: string): string {
  const { parsed, owner, repo } = githubRepository(url);
  for (const parameter of parsed.searchParams.keys()) {
    if (!['ref', 'rev', 'dir'].includes(parameter)) {
      throw new Error(`Cannot safely use snapshots with Git option: ${parameter}`);
    }
  }
  return `github:${owner}/${repo}${parsed.search}`;
}

export function restoreGitLocks(lock: FlakeLock): FlakeLock {
  for (const node of Object.values(lock.nodes)) {
    if (node.original?.type !== 'git' || node.locked?.type !== 'github') {
      continue;
    }
    const { parsed, owner, repo } = githubRepository(node.original.url);
    if (parsed.search || owner.toLowerCase() !== node.locked.owner.toLowerCase() ||
        repo.toLowerCase() !== node.locked.repo.toLowerCase()) {
      throw new Error(`Snapshot does not match original Git repository: ${node.original.url}`);
    }
    for (const attribute of Object.keys(node.original)) {
      if (!['type', 'url', 'ref', 'rev', 'dir'].includes(attribute)) {
        throw new Error(`Cannot safely restore Git attribute: ${attribute}`);
      }
    }
    const { rev, narHash, lastModified } = node.locked;
    if (!rev || !narHash || lastModified === undefined) {
      throw new Error(`Snapshot is missing pinned metadata: ${node.original.url}`);
    }
    node.locked = {
      lastModified,
      narHash,
      ...(node.original.ref !== undefined ? { ref: node.original.ref } : {}),
      rev,
      type: 'git',
      url: node.original.url,
      ...(node.original.dir !== undefined ? { dir: node.original.dir } : {}),
    };
  }
  return lock;
}

async function githubRequest(url: URL): Promise<Response> {
  const token = process.env.GH_TOKEN || process.env.GITHUB_TOKEN;
  const response = await fetch(url, {
    headers: {
      Accept: 'application/vnd.github+json',
      'X-GitHub-Api-Version': '2022-11-28',
      ...(token ? { Authorization: `Bearer ${token}` } : {}),
    },
    signal: AbortSignal.timeout(60_000),
  });
  if (!response.ok) {
    throw new Error(`GitHub metadata request failed (${response.status}): ${url}`);
  }
  return response;
}

export function githubRevCount(headers: Headers): number {
  const pagination = headers.get('link');
  if (!pagination) return 1;
  const last = pagination.split(',').find(link => /;\s*rel="last"/.test(link));
  const target = last?.match(/<([^>]+)>/)?.[1];
  if (!target) throw new Error('GitHub commit history has no last pagination link.');
  const count = Number(new URL(target).searchParams.get('page'));
  if (!Number.isSafeInteger(count) || count < 1) {
    throw new Error('GitHub commit history returned an invalid revision count.');
  }
  return count;
}

export async function completeGitMetadata(lock: FlakeLock): Promise<FlakeLock> {
  for (const node of Object.values(lock.nodes)) {
    const locked = node.locked;
    if (locked?.type !== 'git' || !locked.url.startsWith('https://github.com/')) continue;
    const { owner, repo } = githubRepository(locked.url);
    const repositoryUrl = new URL(`https://api.github.com/repos/${owner}/${repo}`);
    if (locked.ref === undefined) {
      const response = await githubRequest(repositoryUrl);
      const repository = await response.json() as { default_branch?: string };
      if (typeof repository.default_branch !== 'string' || !repository.default_branch) {
        throw new Error(`GitHub returned no default branch for ${owner}/${repo}.`);
      }
      locked.ref = `refs/heads/${repository.default_branch}`;
    }
    if (locked.revCount === undefined) {
      if (!locked.rev) throw new Error(`Git lock has no pinned revision: ${locked.url}`);
      const commitsUrl = new URL(`${repositoryUrl}/commits`);
      commitsUrl.searchParams.set('sha', locked.rev);
      commitsUrl.searchParams.set('per_page', '1');
      const response = await githubRequest(commitsUrl);
      const commits = await response.json() as { sha: string }[];
      if (!Array.isArray(commits) || commits.length !== 1 || commits[0]?.sha !== locked.rev) {
        throw new Error(`GitHub history does not start at the pinned revision: ${locked.url}`);
      }
      locked.revCount = githubRevCount(response.headers);
    }
    console.log(`Git metadata for ${owner}/${repo}@${locked.rev}: ref=${locked.ref}, revCount=${locked.revCount}`);
  }
  return lock;
}

function runNix(args: string[]): string {
  const result = spawnSync('nix', args, {
    encoding: 'utf8',
    stdio: ['inherit', 'pipe', 'inherit'],
    maxBuffer: 32 * 1024 * 1024,
  });
  if (result.error) throw result.error;
  if (result.status !== 0) {
    throw new Error(`nix ${args[0]} failed with status ${result.status}`);
  }
  return result.stdout;
}

async function main(): Promise<void> {
  const lockPath = resolve('flake.lock');
  if (process.argv[2] === '--restore-git-locks') {
    const lock = restoreGitLocks(JSON.parse(readFileSync(lockPath, 'utf8')) as FlakeLock);
    await completeGitMetadata(lock);
    writeFileSync(lockPath, `${JSON.stringify(lock, null, 2)}\n`);
    runNix(['flake', 'metadata', '--offline', '--no-update-lock-file', '--json']);
    return;
  }
  const inputs = JSON.parse(runNix(['eval', '--json', '--file', './flake.nix', 'inputs'])) as Record<string, FlakeInput>;
  const overrides: string[] = [];
  for (const [name, input] of Object.entries(inputs)) {
    if (!input.url?.startsWith('git+https://github.com/')) continue;
    for (const attribute of Object.keys(input)) {
      if (!['url', 'inputs', 'flake'].includes(attribute)) {
        throw new Error(`Unsupported input attribute for ${name}: ${attribute}`);
      }
    }
    const snapshot = snapshotUrl(input.url);
    console.log(`Using snapshot for ${name}: ${snapshot}`);
    overrides.push('--override-input', name, snapshot);
  }
  runNix(['flake', 'update', ...overrides, '--output-lock-file', lockPath]);
  runNix(['flake', 'metadata', '--offline', '--no-update-lock-file', '--json']);
}

if (process.argv[1] && import.meta.url === pathToFileURL(resolve(process.argv[1])).href) {
  await main();
}