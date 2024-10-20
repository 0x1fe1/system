{ inputs, lib, config, pkgs, ... }: {
	imports = [
		./hardware-configuration.nix
	];

	nixpkgs.config.allowUnfree = true;

	nix = /* let flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs; in */ {
		settings = {
			experimental-features = [ "nix-command" "flakes" ];
			# nix-path = config.nix.nixPath;
		};
		channel.enable = false;
		# registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
		# nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
	};

	boot = {
		loader = {
			grub = {
				enable = true;
				device = "nodev";
				useOSProber = true;
				efiSupport = true;
				font = "${
					pkgs.nerdfonts.override{fonts=["FiraCode"];}
				}/share/fonts/truetype/NerdFonts/FiraCodeNerdFont-Regular.ttf";
				fontSize = 36;
			};
			efi = {
				canTouchEfiVariables = true;
				efiSysMountPoint = "/boot/efi";
			};
		};
	};

	networking.hostName = "desktop";
	networking.networkmanager.enable = true;

	# Set your time zone.
	time.timeZone = "Europe/Moscow";
	# FIX dualboot (only on windows) breaks time
	time.hardwareClockInLocalTime = true;

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

	users.users.pango = {
		isNormalUser = true;
		extraGroups = [
			"networkmanager"
			"wheel"
			"docker"
			"podman"
			"video"
			"audio"
			"input"
			"tty"
			"plugdev"
			"dialout"
			"gpio"
		];
	};

	services = {
		xserver = {
			enable = true;
			xkb = {
				layout = "us,ru";
				variant = "qwerty";
				options = "grp:caps_toggle";
			};
			desktopManager.xterm.enable = false;
			windowManager.i3.enable = true;
		};
		displayManager = {
			sddm.enable = true;
			sddm.wayland.enable = true;
			defaultSession = "none+i3";
			autoLogin.enable = true;
			autoLogin.user = "pango";
		};
		# desktopManager.plasma6.enable = true;
		openssh = {
			enable = true;
			settings.PasswordAuthentication = false;
		};
		udev.packages = [ pkgs.bazecor ];
	};

	programs.hyprland.enable = true;
	programs.steam.enable = true;

	# links /libexec from derivations to /run/current-system/sw
	environment.pathsToLink = [ "/libexec" "/share/xdg-desktop-portal" "/share/applications" ];

	environment.sessionVariables = {
		FLAKE = "/home/pango/system";
		NIXOS_OZONE_WL = "1";
		EDITOR = "vim";
	};

	environment.systemPackages = with pkgs; [
		vim
		git
	];

	programs.nix-ld.enable = true;
	programs.nix-ld.libraries = with pkgs; [
		# Add any missing dynamic libraries for unpackaged programs
		# here, NOT in environment.systemPackages
		atk
		cairo
		gdk-pixbuf
		glib
		glibc
		gobject-introspection
		gtk3
		libgudev
		linuxHeaders
		pango
		raylib
		xorg.libX11.dev
	];

	# Enable sound with pipewire.
	hardware.pulseaudio.enable = false;
	security.rtkit.enable = true;
	security.polkit.enable = true;
	services.pipewire = {
		enable = true;
		alsa.enable = true;
		alsa.support32Bit = true;
		pulse.enable = true;
		extraConfig.pipewire = {
			"99-disable-bell" = {
				"context.properties"= {
					"module.x11.bell" = false;
				};
			};
		};
		# If you want to use JACK applications, uncomment this
		#jack.enable = true;

		# use the example session manager
		# (no others are packaged yet so this is enabled by default,
		# no need to redefine it in your config for now)
		#media-session.enable = true;
	};


	system.stateVersion = "24.05";
}
