# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "nvme" "usbhid"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-amd"];
  boot.extraModulePackages = [];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/8c699853-a7cc-420a-a5d3-67c83aa1ed2d";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/7CA8-38DE";
    fsType = "vfat";
    options = ["fmask=0077" "dmask=0077"];
  };

  fileSystems."/hdd" = {
    device = "/dev/sda2";
    fsType = "ntfs3";
    options = ["nosuid" "nodev" "uid=1000" "gid=100" "iocharset=utf8" "uhelper=udisks2"];
  };

  fileSystems."/home/arturo/.local/share/dolphin-emu/Load/Textures/Metroid Prime 1 HD" = {
    device = "/hdd/ROMS/Dolphin textures/Metroid_Prime_1.sfs";
    fsType = "squashfs";
  };

  fileSystems."/home/arturo/.local/share/dolphin-emu/Load/Textures/Metroid Prime 2 HD" = {
    device = "/hdd/ROMS/Dolphin textures/Metroid_Prime_2.sfs";
    fsType = "squashfs";
  };

  fileSystems."/home/arturo/.local/share/dolphin-emu/Load/Textures/Metroid Prime 3 HD" = {
    device = "/hdd/ROMS/Dolphin textures/Metroid_Prime_3.sfs";
    fsType = "squashfs";
  };

  swapDevices = [];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.docker0.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp11s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.vboxnet0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp12s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
