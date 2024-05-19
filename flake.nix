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
    hm = inputs.home-manager;
  in {
    nixosConfigurations = {
      desktop = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/desktop/configuration.nix
          hm.nixosModules.default
        ];
      };
      laptop = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/laptop/configuration.nix
          hm.nixosModules.default
        ];
      };
    };

    homeConfigurations = {
      desktop = hm.lib.homeManagerConfiguration {
        pkgs = pkgs;
        modules = [
          ./hosts/desktop/home.nix
        ];
      };
      laptop = hm.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./hosts/laptop/home.nix
        ];
      };
    };

    packages.${system} = {
      inherit (pkgs) bazecor;
    };
  };
}
