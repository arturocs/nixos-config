{pkgs, ...}: {
  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;
  networking.hostName = "nixosvm"; # Define your hostname.
  virtualisation.virtualbox.guest.enable = true;
  system.activationScripts.createSymlinks.text = ''
    #!/bin/sh
    ln -sf /nix/flatpak /var/lib/flatpak
    ln -sf /nix/nix_cache /home/arturo/.cache/nix/
  '';
}
