{...}: {
  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;
  networking.hostName = "nixos_vm"; # Define your hostname.
  virtualisation.virtualbox.guest.enable = true;
  environment.shellAliases = {
    update = "cd /home/arturo/nixos-config && nix flake update && nh os switch -H nixos_vm .";
    rebuild = "cd /home/arturo/nixos-config && nh os switch -H nixos_vm .";
  };

}
