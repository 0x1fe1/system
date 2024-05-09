{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    overlays = import ./overlays/default.nix {inherit inputs system;};
    # pkgs = nixpkgs.legacyPackages.${system};
    pkgs = import inputs.nixpkgs {
      inherit overlays system;
      config.allowUnfree = true;
    };
  in {
    nixosConfigurations = {
      desktop = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/desktop/configuration.nix
          inputs.home-manager.nixosModules.default
        ];
      };
      laptop = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/laptop/configuration.nix
          inputs.home-manager.nixosModules.default
        ];
      };
    };

    out = {inherit pkgs overlays;};

    packages.${system} = {
      inherit (pkgs) bazecor;
    };
  };
}
