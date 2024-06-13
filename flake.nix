{
    description = "Test flake";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    };

    outputs = { self, nixpkgs, ... }@inputs: {
    # Please replace my-nixos with your hostname
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
      ];
    };
  };
}
