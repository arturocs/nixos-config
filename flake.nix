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
    nixpkgs-unstable.url = "nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager/trunk";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak/latest";
    autofirma-nix.url = "github:nix-community/autofirma-nix/release-24.11";
    nix-software-center.url = "github:snowfallorg/nix-software-center";
    nix-alien.url = "github:thiagokokada/nix-alien";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    chaotic,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    lib = nixpkgs.lib;
    extensions = inputs.nix-vscode-extensions.extensions.${system};
    pkgs-unstable = import nixpkgs-unstable {
      inherit system;
      config = {
        allowUnfree = true;
        allowUnfreePredicate = _: true;
        permittedInsecurePackages = [
          "freeimage-3.18.0-unstable-2024-04-18"
        ];
      };
    };
  in {
    nixosConfigurations = {
      nixosvm = lib.nixosSystem {
        inherit system;
        modules = [
          ./nixosvm/hardware-configuration.nix
          ./nixosvm/configuration.nix
          ./general_configuration.nix
          chaotic.nixosModules.nyx-cache
          chaotic.nixosModules.nyx-overlay
          chaotic.nixosModules.nyx-registry
        ];
        specialArgs = {
          inherit home-manager pkgs-unstable inputs extensions;
        };
      };
      desktop = lib.nixosSystem {
        inherit system;
        modules = [
          ./desktop/hardware-configuration.nix
          ./desktop/configuration.nix
          ./general_configuration.nix
          chaotic.nixosModules.nyx-cache
          chaotic.nixosModules.nyx-overlay
          chaotic.nixosModules.nyx-registry
        ];
        specialArgs = {
          inherit home-manager pkgs-unstable inputs extensions;
        };
      };
    };
  };
}
