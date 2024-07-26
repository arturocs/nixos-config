{
  config,
  pkgs,
  pkgs-unstable,
  home-manager,
  inputs,
  ...
}: {
  nixpkgs.overlays = [inputs.rust-overlay.overlays.default];
  environment.systemPackages = [pkgs.rust-bin.stable.latest.default];
}
