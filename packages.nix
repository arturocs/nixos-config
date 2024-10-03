{
  config,
  pkgs,
  pkgs-unstable,
  home-manager,
  inputs,
  ...
}: let
  python3FullOptimized = pkgs.python3Full.override {
    enableOptimizations = true;
    reproducibleBuild = false;
    self = python3FullOptimized;
  };
in {
  environment.systemPackages = with pkgs; [
    wget
    kate
    alejandra
    python3FullOptimized
    nodePackages_latest.nodejs
    git
    libnotify
    gimp
    gcc
    llvmPackages.libcxxClang
    typora
    telegram-desktop
    libreoffice-qt
    hunspell
    hunspellDicts.es_ES
    hunspellDicts.en_US
    onlyoffice-bin
    gitkraken
    blender
    libsForQt5.skanlite
    chromium
    discord
    freetube
    qbittorrent-qt5
    tor-browser
    teamviewer
    gnome.cheese
    vlc
    libsForQt5.kdenlive
    calibre
    libsForQt5.yakuake
    libsForQt5.filelight
    libsForQt5.libksysguard
    libsForQt5.ktexteditor
    htop
    wineWowPackages.stable
    ncdu
    vdhcoapp
    bless
    virtualbox
    rust-bin.stable.latest.default
    pcmanfm
    neofetch
    gitkraken
    calibre
    inputs.nix-software-center.packages.${system}.nix-software-center
    nh
    postman
    squashfsTools
    libsForQt5.kalk
    pingus
    obs-studio
    skypeforlinux
    teams-for-linux
    lm_sensors
    pciutils
    iw
    inxi
    lshw
    docker-compose
    file
    nvtopPackages.nvidia
    inputs.nix-alien.packages.${system}.nix-alien
    config.boot.kernelPackages.perf
    stremio

  ];
}
