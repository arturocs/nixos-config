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
    nixpkgs.url = "git+https://github.com/NixOS/nixpkgs.git?ref=nixos-25.05";
    nixpkgs-unstable.url = "git+https://github.com/NixOS/nixpkgs.git?ref=nixos-unstable";
    home-manager.url = "git+https://github.com/nix-community/home-manager.git?ref=release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nur = {
      url = "git+https://github.com/nix-community/NUR.git";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rust-overlay = {
      url = "git+https://github.com/oxalica/rust-overlay.git";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "git+https://github.com/nix-community/plasma-manager.git";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    nix-flatpak.url = "git+https://github.com/gmodena/nix-flatpak.git?ref=latest";
    autofirma-nix.url = "git+https://github.com/nix-community/autofirma-nix.git?ref=release-25.05";
    nix-software-center.url = "git+https://github.com/snowfallorg/nix-software-center.git";
    nix-alien.url = "git+https://github.com/thiagokokada/nix-alien.git";
    nix-vscode-extensions.url = "git+https://github.com/nix-community/nix-vscode-extensions.git";
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
      inherit system;
      config = {
        allowUnfree = true;
        allowUnfreePredicate = _: true;
      };
      overlays = [inputs.nix-vscode-extensions.overlays.default];
    };
  in {
    nixosConfigurations = {
      nixosvm = lib.nixosSystem {
        inherit system;
        modules = [
          ./nixosvm/hardware-configuration.nix
          ./nixosvm/configuration.nix
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
