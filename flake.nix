{
  description = "Test flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nur.url = github:nix-community/NUR;
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager/plasma-5";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak?ref=v0.4.1";
    autofirma-nix.url = "github:nilp0inter/autofirma-nix/release-24.05";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    lib = nixpkgs.lib;
    username = "arturo";
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
          inputs.nur.nixosModules.nur
          inputs.nix-flatpak.nixosModules.nix-flatpak

          ({pkgs, ...}: {
            nixpkgs.overlays = [inputs.rust-overlay.overlays.default];
            environment.systemPackages = [pkgs.rust-bin.stable.latest.default];
          })

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.sharedModules = [inputs.plasma-manager.homeManagerModules.plasma-manager];
            home-manager.users."${username}" = import ./home.nix;
          }

          inputs.autofirma-nix.nixosModules.default
          ({
            pkgs,
            config,
            ...
          }: {
            programs.autofirma.enable = true;
            programs.autofirma.fixJavaCerts = true;
            programs.autofirma.firefoxIntegration.enable = true; # Para que Firefox utilice AutoFirma
            programs.configuradorfnmt.enable = true;
            programs.configuradorfnmt.firefoxIntegration.enable = true; # Para que Firefox utilice el Configurador FNMT
          })
        ];
        specialArgs = {
          inherit home-manager pkgs-unstable inputs;
        };
      };
    };
  };
}
