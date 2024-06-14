{
  description = "Test flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    nur.url = github:nix-community/NUR;
  };

  outputs = {
    self,
    nixpkgs,
    nur,
    nixpkgs-unstable,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    lib = nixpkgs.lib;
    pkgs-unstable = import nixpkgs-unstable {
      system = "x86_64-linux";
      config = {
        allowUnfree = true;
        allowUnfreePredicate = _: true;
      };
    };
  in {
    nixosConfigurations = {
      nixos = lib.nixosSystem {
        inherit system;
        modules = [
          ./configuration.nix
          nur.nixosModules.nur
        ];
        specialArgs = {
          inherit pkgs-unstable;
        };
      };
    };
  };
}
