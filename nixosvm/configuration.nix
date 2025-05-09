{pkgs, ...}: {
  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;
  networking.hostName = "nixosvm"; # Define your hostname.
  virtualisation.virtualbox.guest.enable = true;
  system.activationScripts.createFlatpakSymlink.text = ''
    #!/bin/sh
    ln -sf /nix/flatpak /var/lib/flatpak
  '';
}
