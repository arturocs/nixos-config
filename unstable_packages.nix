{
  pkgs-unstable,
  pkgs,
  extensions,
  ...
}: {
  environment.systemPackages = with pkgs-unstable; [
    melonDS
    pcsx2
    dolphin-emu
    godot
    distrobox
    boxbuddy
    retroarch-assets
    retroarch-joypad-autoconfig
    bcachefs-tools
    cura-appimage
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
            ms-python.vscode-pylance
            ms-toolsai.jupyter
            ms-toolsai.vscode-jupyter-slideshow
            ms-pyright.pyright
            ms-toolsai.jupyter-renderers
            ms-toolsai.jupyter-keymap
            eamodio.gitlens
            ms-toolsai.vscode-jupyter-cell-tags
            ms-ceintl.vscode-language-pack-es
            llvm-vs-code-extensions.vscode-clangd
            tamasfe.even-better-toml
            batisteo.vscode-django
            mhutchie.git-graph
            svelte.svelte-vscode
            github.copilot
            github.copilot-chat
          ])
          ++ (with vscode-marketplace; [
            ms-python.autopep8
          ])
          ++ (with vscode-marketplace-release; [
            rust-lang.rust-analyzer
          ]);
      })
  ];
}
