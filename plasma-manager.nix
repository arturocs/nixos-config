{
  pkgs,
  home-manager,
  inputs,
  ...
}: {
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.sharedModules = [inputs.plasma-manager.homeManagerModules.plasma-manager];
  home-manager.users.arturo = import ./home.nix;
}
