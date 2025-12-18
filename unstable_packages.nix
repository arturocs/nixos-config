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
    ares
    rmg
    godot
    distrobox
    boxbuddy
    retroarch-assets
    retroarch-joypad-autoconfig
    bcachefs-tools
    cura-appimage
    llama-cpp
    hydralauncher
    # Launch command on wayland
    # env __GLX_VENDOR_LIBRARY_NAME=mesa __EGL_VENDOR_LIBRARY_FILENAMES=/run/opengl-driver/share/glvnd/egl_vendor.d/50_mesa.json MESA_LOADER_DRIVER_OVERRIDE=zink GALLIUM_DRIVER=zink WEBKIT_DISABLE_DMABUF_RENDERER=1 orca-slicer
    orca-slicer
    antigravity-fhs
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
          ])
          ++ (with vscode-marketplace; [
            ])
          ++ (with vscode-marketplace-release; [
            ms-python.autopep8
            github.copilot
            github.copilot-chat
            rust-lang.rust-analyzer
          ])
          ++ (with open-vsx; [
            ]);
      })
  ];
}
