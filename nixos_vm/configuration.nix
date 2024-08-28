{...}: {
  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;
  networking.hostName = "nixos_vm"; # Define your hostname.
  virtualisation.virtualbox.guest.enable = true;
}
