# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  home-manager,
  inputs,
  pkgs-unstable,
  lib,
  ...
}: {
  imports = [
    inputs.nur.modules.nixos.default
    home-manager.nixosModules.home-manager
    inputs.nix-flatpak.nixosModules.nix-flatpak
    inputs.autofirma-nix.nixosModules.default
    ./packages.nix
    ./unstable_packages.nix
    ./stupid_packages.nix
    ./plasma_overlay.nix
  ];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.tmp.cleanOnBoot = true;
  hardware.enableAllFirmware = true;
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  nix.settings = {
    auto-optimise-store = true;
    experimental-features = ["nix-command" "flakes"];
    substituters = [
      "https://nix-community.cachix.org"
      "https://cuda-maintainers.cachix.org"
      "https://cache.nixos.org/"
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
    ];
  };

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Madrid";

  # Select internationalisation properties.
  i18n.defaultLocale = "es_ES.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_ES.UTF-8";
    LC_IDENTIFICATION = "es_ES.UTF-8";
    LC_MEASUREMENT = "es_ES.UTF-8";
    LC_MONETARY = "es_ES.UTF-8";
    LC_NAME = "es_ES.UTF-8";
    LC_NUMERIC = "es_ES.UTF-8";
    LC_PAPER = "es_ES.UTF-8";
    LC_TELEPHONE = "es_ES.UTF-8";
    LC_TIME = "es_ES.UTF-8";
  };

  systemd.services.NetworkManager-wait-online.enable = false;
  systemd.services.ModemManager.enable = false;
  systemd.services.upower.enable = false;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.excludePackages = [pkgs.xterm];

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    discover
    elisa
  ];

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "es";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "es";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # EarlyOOM
  services.systembus-notify.enable = true;
  services.earlyoom.enable = true;
  services.earlyoom.enableNotifications = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.arturo = {
    isNormalUser = true;
    description = "arturo";
    extraGroups = ["networkmanager" "wheel" "vboxusers" "docker"];
    packages = with pkgs; [
    ];
  };

  home-manager.extraSpecialArgs = {inherit inputs;};
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.sharedModules = [inputs.plasma-manager.homeModules.plasma-manager];
  home-manager.users.arturo = import ./home.nix;

  programs.autofirma = {
    enable = true;
    firefoxIntegration.enable = true;
  };

  # The FNMT certificate configurator
  programs.configuradorfnmt = {
    enable = true;
    firefoxIntegration.enable = true;
  };

  # Firefox configured to work with AutoFirma
  programs.firefox = {
    enable = true;
    policies.SecurityDevices = {
      "OpenSC PKCS#11" = "${pkgs.opensc}/lib/opensc-pkcs11.so";
    };
  };

  # Hacky fix to autofirma error
  environment.etc."AutoFirma/autofirma.pfx".source = "/home/arturo/.afirma/AutoFirma/autofirma.pfx";

  programs.java.enable = true;
  networking.extraHosts = "127.0.0.1 release.gitkraken.com";

  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      dates = "daily";
      extraArgs = "--keep 3";
    };
  };

  programs.git = {
    enable = true;
    lfs.enable = true;
  };
  programs.appimage.enable = true;
  programs.appimage.binfmt = true;
  programs.appimage.package = pkgs.appimage-run.override {
    extraPkgs = pkgs:
      with pkgs; [
        espeak-ng
      ];
  };
  nixpkgs.overlays = [
    inputs.rust-overlay.overlays.default
    (self: super: {
      # try again in 25.04 https://github.com/NixOS/nixpkgs/issues/372679
      # stdenv = (super.withCFlags ["-O3" "-flto"] super.stdenv) // {
      stdenv =
        super.stdenv
        // {
          useMoldLinker = true;
          impureUseNativeOptimizations = true;
        };
    })
  ];

  # Allow unfree packages
  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [];
  };
  security.polkit.enable = true;

  virtualisation.docker.enable = true;
  virtualisation.docker.enableOnBoot = false;

  fonts.packages = with pkgs; [
    corefonts
  ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  programs.firefox.languagePacks = ["es-ES"];

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Add any missing dynamic libraries for unpackaged
    # programs here, NOT in environment.systemPackages
  ];
  programs.partition-manager.enable = true;
  services.flatpak.enable = true;
  services.flatpak.update.auto.enable = true;
  services.flatpak.uninstallUnmanaged = true;
  services.flatpak.packages = [
    "com.heroicgameslauncher.hgl"
    "org.jdownloader.JDownloader"
    "io.dbeaver.DBeaverCommunity"
    "com.github.afrantzis.Bless"
    "com.github.tchx84.Flatseal"
    "com.stremio.Stremio"
  ];

  services.teamviewer = {
    enable = true;
    package = pkgs-unstable.teamviewer;
  };
  services.system76-scheduler.enable = true;
  services.xserver.xautolock.time = 99999;
  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.host.enableKvm = true;
  virtualisation.virtualbox.host.addNetworkInterface = false;
  users.extraGroups.vboxusers.members = ["arturo"];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  zramSwap.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  environment.shellAliases = {
    update = "pushd /home/arturo/nixos-config ; nix flake update ; nh os switch -H $HOSTNAME . ; popd";
    rebuild = "pushd /home/arturo/nixos-config ; nh os switch -H $HOSTNAME . ; popd";
    edconf = "code /home/arturo/nixos-config";
    off = "poweroff";
  };

  environment.etc."current-system-packages".text = let
    packages = builtins.map (p: "${p.name}") config.environment.systemPackages;
    sortedUnique = builtins.sort builtins.lessThan (pkgs.lib.lists.unique packages);
    formatted = builtins.concatStringsSep "\n" sortedUnique;
  in
    formatted;
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
