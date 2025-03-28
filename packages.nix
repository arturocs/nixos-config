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
    nodePackages_latest.nodejs
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
    chromium
    discord
    tor-browser
    teamviewer
    vlc
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
    gitkraken
    calibre
    inputs.nix-software-center.packages.${system}.nix-software-center
    nh
    postman
    squashfsTools
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
    appimage-run
    lz4
    p7zip
    thunderbird
    lsof
    zip
    dolphin-emu-primehack
    mold
  ];
}
