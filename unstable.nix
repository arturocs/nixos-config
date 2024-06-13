{
  config,
  pkgs,
  ...
}: let
  unstable =
    import
    (builtins.fetchTarball "channel:nixos-unstable")
    {config = config.nixpkgs.config;};
in {
  environment.systemPackages = with pkgs.unstable; [
    (
      vscode-with-extensions.override {
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
      }
    )
  ];
}
