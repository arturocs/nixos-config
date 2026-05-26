{
  pkgs-unstable,
  pkgs,
  extensions,
  ...
}: {
  environment.systemPackages = with pkgs-unstable; [
    # Emulators
    melonds
    pcsx2
    dolphin-emu
    ares
    rmg
    mgba
    godot
    retroarch-assets
    retroarch-joypad-autoconfig
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

    # Development tools
    antigravity-fhs
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

    # Slicers
    orca-slicer
    cura-appimage

    # Other packages
    hydralauncher
    lmstudio
    dwarfs
  ];
}
