{
  description = "My Awesome Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    # nvix.url = "github:Pangolecimal/nvix";
  };

  outputs = {
    self,
    nixpkgs,
    # nvix,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
      };
    };
  in {
    nixosConfigurations = {
      PangoliNix = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit pkgs inputs system;};

        modules = [
          ./nixos/configuration.nix
          # {
          #   environment.systemPackages = [
          #       nvix
          #   ];
          # }
        ];
      };
    };
  };
}
