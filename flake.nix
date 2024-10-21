{
	description = "Pango's laptop NixOS Config";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
		home-manager.url = "github:nix-community/home-manager";
		home-manager.inputs.nixpkgs.follows = "nixpkgs";
	};

	outputs = {
		self,
		nixpkgs,
		home-manager,
		...
	} @ inputs: let inherit (self) outputs; in {
		# Available through `sudo nixos-rebuild switch --flake .#laptop`
		nixosConfigurations = {
			laptop = nixpkgs.lib.nixosSystem {
				specialArgs = { inherit inputs outputs; };
				modules = [ ./nixos/configuration.nix ];
			};
		};

		# Available through `home-manager switch --flake .#pango@laptop`
		homeConfigurations = {
			"pango@laptop" = home-manager.lib.homeManagerConfiguration {
				pkgs = nixpkgs.legacyPackages.x86_64-linux;
				extraSpecialArgs = { inherit inputs outputs; };
				modules = [ ./home-manager/home.nix ];
			};
		};
	};
}
