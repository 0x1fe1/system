# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
	inputs,
	lib,
	config,
	pkgs,
	...
}: {
	# You can import other home-manager modules here
	imports = [
		# If you want to use home-manager modules from other flakes (such as nix-colors):
		# inputs.nix-colors.homeManagerModule

		# You can also split up your configuration and import pieces of it here:
		# ./nvim.nix
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
			# Workaround for https://github.com/nix-community/home-manager/issues/2942
			allowUnfreePredicate = _: true;
		};
	};

	home = {
		username = "pango";
		homeDirectory = "/home/pango";
	};

	# Add stuff for your user as you see fit:
	home.packages = with pkgs; [
		python3
		ngrok
		# kitty
		# xfce.exo
	];

	programs.home-manager.enable = true;

	programs.bash = {
		enable = true;
		shellAliases = {
			v="nix run ~/neovim";
			cn="pushd ~/system && nix run ~/neovim ~/system && popd";
			fn="sudo nixos-rebuild switch --flake ~/system#server";
			hn="home-manager switch --flake ~/system#pango@server";
		};
	};

	programs.neovim.enable = true;
	programs.zoxide.enable = true;
	programs.fzf.enable = true;
	programs.ripgrep.enable = true;
	programs.eza.enable = true;
	programs.bat.enable = true;

	programs.zellij = {
		enable = true;
		settings.theme = "catppuccin-mocha";
	};

	programs.direnv = {
		enable = true;
		enableBashIntegration = true;
		nix-direnv.enable = true;
	};

	programs.git = {
		enable = true;
		userName = "0x1fe1";
		userEmail = "pangolecimal@gmail.com";
		extraConfig = {
			init.defaultBranch = "main";
		};

		aliases = {
			ignore = ''!git-ignore-fn() { curl -sL https://www.toptal.com/developers/gitignore/api/$@ ;}; git-ignore-fn'';
		};

		delta = {
			enable = true;
			options = {
				features = "decorations";
				dark = true;
				line-numbers = true;
				side-by-side = false;
				true-color = "always";
				decorations = {
					commit-decoration-style = "lightblue ol";
					commit-style = "raw";
					file-style = "omit";
					hunk-header-decoration-style = "lightblue box";
					hunk-header-file-style = "pink";
					hunk-header-line-number-style = "lightgreen";
					hunk-header-style = "file line-number syntax";
				};
				interactive = {
					keep-plus-minus-markers = false;
				};
			};
		};
	};


	# Nicely reload system units when changing configs
	systemd.user.startServices = "sd-switch";

	# https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
	home.stateVersion = "24.05";
}
