# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
	inputs,
	lib,
	config,
	pkgs,
	...
}: {
	# You can import other NixOS modules here
	imports = [
		# If you want to use modules from other flakes (such as nixos-hardware):
		# inputs.hardware.nixosModules.common-cpu-amd
		# inputs.hardware.nixosModules.common-ssd

		# You can also split up your configuration and import pieces of it here:
		# ./users.nix

		# Import your generated (nixos-generate-config) hardware configuration
		./hardware-configuration.nix
	];

	nixpkgs = {
		# You can add overlays here
		overlays = [
			# If you want to use overlays exported from other flakes:
			# neovim-nightly-overlay.overlays.default

			# Or define it inline, for example:
			# (final: prev: {
			#	 hi = final.hello.overrideAttrs (oldAttrs: {
			#		 patches = [ ./change-hello-to-hi.patch ];
			#	 });
			# })
		];
		# Configure your nixpkgs instance
		config = {
			# Disable if you don't want unfree packages
			allowUnfree = true;
		};
	};

	nix = let flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs; in {
		settings = {
			# Enable flakes and new 'nix' command
			experimental-features = [ "nix-command" "flakes" ];
			# Opinionated: disable global registry
			# flake-registry = "";
			# Workaround for https://github.com/NixOS/nix/issues/9574
			nix-path = config.nix.nixPath;
		};
		# Opinionated: disable channels
		channel.enable = false;

		# Opinionated: make flake registry and nix path match flake inputs
		registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
		nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
	};

	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;

	networking.hostName = "server";
	networking.networkmanager.enable = true;
	networking.firewall = {
		enable = true;
		allowedTCPPorts = [ 6969 ];
		allowedUDPPorts = [ 6970 ];
	};

	# Set your time zone.
	time.timeZone = "Europe/Moscow";

	# Select internationalisation properties.
	i18n.defaultLocale = "en_US.UTF-8";

	i18n.extraLocaleSettings = {
		LC_ADDRESS = "ru_RU.UTF-8";
		LC_IDENTIFICATION = "ru_RU.UTF-8";
		LC_MEASUREMENT = "ru_RU.UTF-8";
		LC_MONETARY = "ru_RU.UTF-8";
		LC_NAME = "ru_RU.UTF-8";
		LC_NUMERIC = "ru_RU.UTF-8";
		LC_PAPER = "ru_RU.UTF-8";
		LC_TELEPHONE = "ru_RU.UTF-8";
		LC_TIME = "ru_RU.UTF-8";
	};

	# Enable the X11 windowing system.
	# services.xserver.enable = true;
	# services.xserver.displayManager.startx.enable = true;

	# Enable the XFCE Desktop Environment.
	# services.xserver.displayManager.lightdm.enable = true;
	# services.xserver.desktopManager.xfce.enable = true;

	# Configure keymap in X11
	# services.xserver.xkb = {
	# 	layout = "us,ru";
	# 	variant = "qwerty";
	# 	options = "grp:win_space_toggle";
	# };

	users.users.pango = {
		isNormalUser = true;
		openssh.authorizedKeys.keys = [
			"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDyFLwmHGcdqVWh3+bQAsX9FITY5LQ0yS/d8nAsQdO37 domkuzaleza@gmail.com"
			"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM2slVNoAgWt7Uv6jA7Nq2KYsAYxShLUMeoymNwpwk+l domkuzaleza@gmail.com"
		];
		extraGroups = [ "wheel" "networkmanager" ];
	};

	# This setups a SSH server. Very important if you're setting up a headless system.
	# Feel free to remove if you don't need it.
	services.openssh = {
		enable = true;
		settings = {
			PasswordAuthentication = false;
		};
	};


	# https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
	system.stateVersion = "24.05";
}
