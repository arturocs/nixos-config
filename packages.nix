{
  config,
  pkgs,
  inputs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    wget
    kate
    alejandra
    (python3Full.override {
      enableOptimizations = true;
      reproducibleBuild = false;
    })
    #nodePackages_latest.nodejs
    nodejs
    git
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
    tor-browser
    teamviewer
    cheese
    vlc
    libsForQt5.kdenlive
    calibre
    libsForQt5.yakuake
    libsForQt5.filelight
    libsForQt5.libksysguard
    libsForQt5.ktexteditor
    libsForQt5.kio-admin
    htop
    wineWowPackages.stable
    ncdu
    vdhcoapp
    ghex
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
    teams-for-linux
    lm_sensors
    pciutils
    iw
    inxi
    lshw
    docker-compose
    file
    inputs.nix-alien.packages.${system}.nix-alien
    config.boot.kernelPackages.perf
    libsForQt5.kfind
    appimage-run
    lz4
    p7zip
    thunderbird
    orca-slicer
  ];
}
