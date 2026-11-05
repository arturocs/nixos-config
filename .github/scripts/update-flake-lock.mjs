import { readFileSync, writeFileSync } from 'node:fs';
import { resolve } from 'node:path';
import { spawnSync } from 'node:child_process';
import { pathToFileURL } from 'node:url';

function githubRepository(url) {
  const parsed = new URL(url);
  const parts = parsed.pathname.replace(/\.git$/, '').split('/').filter(Boolean);
  if (!['git+https:', 'https:'].includes(parsed.protocol) ||
      parsed.host !== 'github.com' || parsed.username || parsed.password ||
      parsed.hash || parts.length !== 2) {
    throw new Error(`Unsupported GitHub Git URL: ${url}`);
  }
  return { parsed, owner: parts[0], repo: parts[1] };
}

export function snapshotUrl(url) {
  const { parsed, owner, repo } = githubRepository(url);
  for (const parameter of parsed.searchParams.keys()) {
    if (!['ref', 'rev', 'dir'].includes(parameter)) {
      throw new Error(`Cannot safely use snapshots with Git option: ${parameter}`);
    }
  }
  return `github:${owner}/${repo}${parsed.search}`;
}

export function restoreGitLocks(lock) {
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

function runNix(args) {
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

function main() {
  const inputs = JSON.parse(runNix(['eval', '--json', '--file', './flake.nix', 'inputs']));
  const overrides = [];
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
  const lockPath = resolve('flake.lock');
  runNix(['flake', 'update', ...overrides, '--output-lock-file', lockPath]);
  const lock = restoreGitLocks(JSON.parse(readFileSync(lockPath, 'utf8')));
  writeFileSync(lockPath, `${JSON.stringify(lock, null, 2)}\n`);
  runNix(['flake', 'metadata', '--offline', '--no-update-lock-file', '--json']);
}

if (process.argv[1] && import.meta.url === pathToFileURL(resolve(process.argv[1])).href) {
  main();
}