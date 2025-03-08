{
  config,
  pkgs,
  pkgs-unstable,
  ...
}: {
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = false;
  networking.networkmanager.wifi.powersave = false;
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 3;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.tmp.useTmpfs = true;
  boot.tmp.tmpfsSize = "75%";
  networking.hostName = "desktop"; # Define your hostname.
  #networking.networkmanager.wifi.backend = "iwd";
  boot.kernelParams = ["iwlmvm.power_scheme=1"];
  # Enable OpenGL
  hardware.graphics.enable = true;

  nixpkgs.config.nvidia.acceptLicense = true;
  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];
  environment.systemPackages = [
    pkgs.nvtopPackages.nvidia
  ];
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
    #package = pkgs-unstable.linuxKernel.packages.linux_6_13.nvidia_x11;
    package = config.boot.kernelPackages.nvidiaPackages.latest;
  };
}
