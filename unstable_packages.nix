{
  config,
  pkgs,
  pkgs-unstable,
  home-manager,
  inputs,
  ...
}: {
  environment.systemPackages = with pkgs-unstable; [
    mgba
    orca-slicer
    ghidra-bin
    melonDS
    duckstation
    pcsx2
    dolphin-emu
    snes9x-gtk
    rmg
    ollama
    godot_4
    distrobox
    boxbuddy
    minetest
    retroarch-assets
    retroarch-joypad-autoconfig
    mame-tools
    nixd
    (retroarch.override {
      cores = with libretro; [
        genesis-plus-gx
        snes9x
        beetle-psx-hw
        mesen
        mgba
        mame
        mupen64plus
        gambatte
        melonds
        ppsspp
        pcsx2
        dolphin
      ];
    })
    (vscode-with-extensions.override
      {
        vscodeExtensions = with vscode-extensions; [
          bbenoist.nix
          ms-python.python
          ms-azuretools.vscode-docker
          ms-vscode-remote.remote-ssh
          rust-lang.rust-analyzer
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
          vadimcn.vscode-lldb
        ];
      })
  ];
}
