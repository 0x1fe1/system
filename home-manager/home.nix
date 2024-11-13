{ inputs, lib, config, pkgs, ... }@other: {
	imports = [
		./packages.nix
		./shell.nix
		./terminals.nix
		./hyprland.nix
		./i3.nix
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
	home.file.".icons/default".source = "${pkgs.banana-cursor}/share/icons/Banana";
	home.file.".Xresources".text = ''
		*dpi: 200
		Xft.dpi: 200
		Xcursor.theme: default
	'';

	# Nicely reload system units when changing configs
	systemd.user.startServices = "sd-switch";
}
