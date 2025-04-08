{
  pkgs-unstable,
  pkgs,
  extensions,
  ...
}: {
  environment.systemPackages = with pkgs-unstable; [
    ghidra-bin
    melonDS
    pcsx2
    dolphin-emu
    godot_4
    distrobox
    boxbuddy
    retroarch-assets
    retroarch-joypad-autoconfig
    mame-tools
    qbittorrent
    bcachefs-tools
    (emulationstation-de.override {
      libgit2 = pkgs.libgit2;
      icu = pkgs.icu;
    })
    freetube
    stremio
    cura-appimage
    orca-slicer
    llama-cpp
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
            github.copilot
            ms-python.vscode-pylance
            ms-toolsai.jupyter
            ms-toolsai.vscode-jupyter-slideshow
            ms-pyright.pyright
            ms-toolsai.jupyter-renderers
            ms-toolsai.jupyter-keymap
            eamodio.gitlens
            ms-toolsai.vscode-jupyter-cell-tags
            ms-ceintl.vscode-language-pack-es
            github.copilot-chat
            llvm-vs-code-extensions.vscode-clangd
            tamasfe.even-better-toml
            batisteo.vscode-django
          ])
          ++ (with extensions.vscode-marketplace; [
            ms-python.autopep8
            rust-lang.rust-analyzer
            svelte.svelte-vscode
          ]);
      })
  ];
}
