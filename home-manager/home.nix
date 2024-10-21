{ inputs, lib, config, pkgs, ... }@other: {
	imports = [
		./packages.nix
		./shell.nix
		./terminals.nix
		./hyprland.nix
		# ./i3.nix
	];

	nixpkgs = {
		config = {
			allowUnfree = true;
			allowUnfreePredicate = _: true;
		};
	};

	programs.home-manager.enable = true;
	home = {
		username = "pango";
		homeDirectory = "/home/pango";
		stateVersion = "24.05";
	};

	fonts.fontconfig = {
		enable = true;
		defaultFonts = {
			emoji = [ "Noto Emoji" ];
			monospace = [ "Iosevka" ];
		};
	};

	xdg.portal = {
		enable = true;
		extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
		config.common.default = [ "gtk" ];
	};

	# Nicely reload system units when changing configs
	systemd.user.startServices = "sd-switch";
}
