{
  config,
  pkgs,
  inputs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    wget
    alejandra
    (python314.override {
      enableOptimizations = true;
      reproducibleBuild = false;
    })
    nodePackages_latest.nodejs
    gimp
    typora
    telegram-desktop
    libreoffice-qt
    hunspell
    hunspellDicts.es_ES
    hunspellDicts.en_US
    onlyoffice-desktopeditors
    blender
    chromium
    discord
    tor-browser
    vlc
    kdePackages.kate
    kdePackages.kdenlive
    kdePackages.yakuake
    kdePackages.filelight
    kdePackages.kalk
    kdePackages.kfind
    htop
    wineWowPackages.stable
    ncdu
    vdhcoapp
    (rust-bin.stable.latest.default.override {
      extensions = ["rust-src"];
    })
    pcmanfm
    neofetch
    calibre
    inputs.nix-software-center.packages.${system}.nix-software-center
    squashfsTools
    obs-studio
    teams-for-linux
    lm_sensors
    lshw
    docker-compose
    file
    inputs.nix-alien.packages.${system}.nix-alien
    perf
    lz4
    p7zip
    zip
    dolphin-emu-primehack
    unrar
    ghidra-bin
    mame-tools
    freetube
    gh
    nixpkgs-review
    postman
    nvidia-container-toolkit
    transmission_4-qt6
    libjxl
    ntfs3g
    exiftool
    inetutils
    ocrmypdf
    android-file-transfer
    mozjpeg
    uv
    distrobox
    boxbuddy
  ];
}
