{
  pkgs-unstable,
  pkgs,
  extensions,
  ...
}: {
  environment.systemPackages = with pkgs-unstable; [
    melonds
    pcsx2
    dolphin-emu
    ares
    rmg
    mgba
    godot
    retroarch-assets
    retroarch-joypad-autoconfig
    cura-appimage
    hydralauncher
    orca-slicer
    antigravity-fhs
    lmstudio
    dwarfs
    (retroarch.withCores (
      cores:
        with libretro; [
          genesis-plus-gx
          snes9x
          beetle-psx-hw
          mesen
          mame
          mgba
          gambatte
          melonds
          ppsspp
          pcsx2
          dolphin
          fbneo
          parallel-n64
        ]
    ))
    (vscode-with-extensions.override
      {
        vscodeExtensions =
          (with vscode-extensions; [
            jnoortheen.nix-ide
            ms-python.python
            ms-azuretools.vscode-docker
            ms-vscode-remote.remote-ssh
            ms-python.vscode-pylance
            ms-pyright.pyright
            eamodio.gitlens
            ms-ceintl.vscode-language-pack-es
            llvm-vs-code-extensions.vscode-clangd
            tamasfe.even-better-toml
            batisteo.vscode-django
            mhutchie.git-graph
            svelte.svelte-vscode
            github.copilot-chat
          ])
          ++ (with vscode-marketplace; [
            ])
          ++ (with vscode-marketplace-release; [
            ms-python.autopep8
            rust-lang.rust-analyzer
          ])
          ++ (with open-vsx; [
            ]);
      })
  ];
}
