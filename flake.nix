{
  description = "Test flake";
  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://cuda-maintainers.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-24.11";
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
    nix-software-center.url = "github:snowfallorg/nix-software-center";
    nix-alien.url = "github:thiagokokada/nix-alien";
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
    pkgs-unstable = import nixpkgs-unstable {
      system = "x86_64-linux";
      config = {
        allowUnfree = true;
        allowUnfreePredicate = _: true;
      };
    };
  in {
    nixosConfigurations = {
      nixos_vm = lib.nixosSystem {
        inherit system;
        modules = [
          ./nixos_vm/hardware-configuration.nix
          ./nixos_vm/configuration.nix
          ./general_configuration.nix
        ];
        specialArgs = {
          inherit home-manager pkgs-unstable inputs;
        };
      };
      desktop = lib.nixosSystem {
        inherit system;
        modules = [
          ./desktop/hardware-configuration.nix
          ./desktop/configuration.nix
          ./general_configuration.nix
        ];
        specialArgs = {
          inherit home-manager pkgs-unstable inputs;
        };
      };
    };
  };
}
