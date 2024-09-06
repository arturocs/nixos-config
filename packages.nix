{
  config,
  pkgs,
  pkgs-unstable,
  home-manager,
  inputs,
  ...
}: let
  python3Optimized = pkgs.python3.override {
    enableOptimizations = true;
    reproducibleBuild = false;
    self = python3Optimized;
  };
in {
  environment.systemPackages = with pkgs; [
    wget
    kate
    alejandra
    python3Optimized
    nodejs_22
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
    partition-manager
    htop
    wineWowPackages.stable
    ncdu
    vdhcoapp
    bless
    virtualbox
    rust-bin.stable.latest.default
    pcmanfm
    neofetch
    distrobox
    boxbuddy
    gitkraken
    calibre
    inputs.nix-software-center.packages.${system}.nix-software-center
    nh
    postman
    squashfsTools
    libsForQt5.kalk
    pingus
    minetest
    obs-studio
    skypeforlinux
    teams-for-linux
    lm_sensors
    pciutils
    iw
  ];
}
