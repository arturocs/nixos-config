{
  config,
  pkgs,
  pkgs-unstable,
  ...
}: {
  imports = [
    ./storage.nix
  ];
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = false;
  hardware.cpu.amd.updateMicrocode = true;
  networking.networkmanager.wifi.powersave = false;
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 3;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.tmp.useTmpfs = true;
  boot.tmp.tmpfsSize = "75%";
  networking.hostName = "desktop"; # Define your hostname.

  # networking.bonds.bond0 = {
  #   interfaces = ["enp11s0" "wlp12s0"];
  #   driverOptions = {
  #     mode = "balance-alb";
  #     miimon = "100";
  #   };
  # };

  # networking.interfaces.bond0.useDHCP = true;
  # networking.interfaces.enp11s0.useDHCP = false;
  # networking.interfaces.wlp12s0.useDHCP = false;

  #networking.networkmanager.wifi.backend = "iwd";
  boot.kernelParams = ["iwlmvm.power_scheme=1"];
  # Enable OpenGL
  hardware.graphics.enable = true;
  hardware.nvidia-container-toolkit.enable = true;
  nixpkgs.config.nvidia.acceptLicense = true;
  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];
  environment.systemPackages = [
    pkgs.nvtopPackages.nvidia
  ];

  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true; # only needed for Wayland -- omit this when using with Xorg
    openFirewall = true;
    package = pkgs.sunshine.override {
      cudaSupport = true;
      cudaPackages = pkgs.cudaPackages;
    };
  };

  virtualisation.docker.daemon.settings.features.cdi = true;
  virtualisation.virtualbox.host.enableKvm = true;
  virtualisation.virtualbox.host.addNetworkInterface = false;

  hardware.nvidia = {
    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
    # of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of
    # supported GPUs is at:
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    #package = pkgs.linuxKernel.packages.linux_6_18.nvidia_x11;
    #package = pkgs.linuxPackages_latest.nvidia_x11;
    #package = pkgs-unstable.linuxPackages_latest.nvidia_x11;
    package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      version = "610.57.04";
      sha256_64bit = "sha256-suk1xmuDuwDAyFe8jg7g/VLekoa0DJzB7sKafOfrEW0=";
      sha256_aarch64 = "sha256-QCefrMBCmpOwuOyXv1k5Gj0iB2CYlPgnG3JToUw/j54=";
      openSha256 = "sha256-rQHOOOY4KL92Ww3KDwh+j4eGU7oNAH8LutZC5wmFnPo=";
      settingsSha256 = "sha256-ZEMo8I8Zc2Tq6RVDNYpAH+f094dUaZiBqO+5f6lIjRI=";
      persistencedSha256 = "sha256-aXmD2VY1RLlgAnlHhOUMWzvMyhI6JTClcFLm4imF/mA=";
    };
  };
}
