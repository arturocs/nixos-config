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
  virtualisation.containers.enable = true;
  virtualisation = {
    podman = {
      enable = true;
      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;
      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  # Useful other development tools
  environment.systemPackages = with pkgs; [
    docker-compose # start group of containers for dev
    #podman-compose # start group of containers for dev
  ];
}
