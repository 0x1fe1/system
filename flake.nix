{
	description = "Pango's Server NixOS Config";

	inputs = {
		# Nixpkgs
		nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

		# Home manager
		home-manager.url = "github:nix-community/home-manager";
		home-manager.inputs.nixpkgs.follows = "nixpkgs";
	};

	outputs = {
		self,
		nixpkgs,
		home-manager,
		...
	} @ inputs: let inherit (self) outputs; in {
		# NixOS configuration entrypoint
		# Available through `nixos-rebuild --flake .#server`
		nixosConfigurations = {
			server = nixpkgs.lib.nixosSystem {
				specialArgs = { inherit inputs outputs; };
				modules = [ ./nixos/configuration.nix ];
			};
		};

		# Standalone home-manager configuration entrypoint
		# Available through `home-manager --flake .#pango@server`
		homeConfigurations = {
			"pango@server" = home-manager.lib.homeManagerConfiguration {
				pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
				extraSpecialArgs = { inherit inputs outputs; };
				modules = [ ./home-manager/home.nix ];
			};
		};
	};
}
