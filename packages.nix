{
  config,
  pkgs,
  inputs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    # Development tools
    (python314.override {
      enableOptimizations = true;
      reproducibleBuild = false;
    })
    (rust-bin.stable.latest.default.override {
      extensions = ["rust-src"];
    })
    nodePackages_latest.nodejs
    alejandra
    docker-compose
    nvidia-container-toolkit
    nixpkgs-review
    postman
    uv
    gh

    # Office 
    libreoffice-qt
    hunspell
    hunspellDicts.es_ES
    hunspellDicts.en_US
    onlyoffice-desktopeditors
    typora

    # CLI tools
    wget
    htop
    ncdu
    neofetch
    squashfsTools
    lm_sensors
    lshw
    file
    perf
    lz4
    p7zip
    zip
    unrar
    mame-tools
    libjxl
    ntfs3g
    exiftool
    inetutils
    mozjpeg
    ocrmypdf
    distrobox
    inputs.nix-alien.packages.${system}.nix-alien

    # Multimedia
    gimp
    calibre
    vlc
    blender
    obs-studio

    # Internet 
    telegram-desktop
    chromium
    discord
    tor-browser
    teams-for-linux
    freetube
    transmission_4-qt6
    
    # KDE applications
    kdePackages.kate
    kdePackages.kdenlive
    kdePackages.yakuake
    kdePackages.filelight
    kdePackages.kalk
    kdePackages.kfind

    # Others
    wineWowPackages.stable
    pcmanfm
    inputs.nix-software-center.packages.${system}.nix-software-center
    boxbuddy
    dolphin-emu-primehack
    ghidra-bin
    android-file-transfer
  ];
}
