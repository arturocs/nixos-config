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
    heroic
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