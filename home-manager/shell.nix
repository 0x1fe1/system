{ lib, ... }@inputs: let aliases = import ./aliases.nix; in {
	programs = {
		bash = {
			enable = true;
			historyControl = [ "ignorespace" ];
			shellAliases = {
				lla = "eza -Tl -s=type --no-user --no-time --git-ignore";
				ll = "lla -L=1";
				ls = "ls --color";
				c = "clear";
				q = "exit";
				":q" = "exit";
				".." = "cd ..";

				# [J]ump to (zoxide)
				j = "z";
				"j-" = "j -"; # Jump to [-] (previous directory)
				jp = "j ~/personal"; # Jump to [P]ersonal
				js = "j ~/system"; # Jump to [S]ystem
				jn = "j ~/neovim"; # Jump to [N]eovim
				jm = "j ~/mirea"; # Jump to [M]irea

				# [V]im (nvim built with nixvim)
				v = "nix run ~/neovim";
				"v." = "v ."; # [V]im [.] open vim in current directory

				# [F]zf [F]unction (the underlying search directories function)
				ff = "fd . --type directory --max-depth=16 | fzf --border=rounded";

				# nix-direnv
				da = "direnv allow";
				dn = "direnv deny";

				# [C]onfigure [N]ixos (goto ~/system and enter vim)
				cn = "custom-system-edit";
				# [F]lake rebuild [N]ixos (switch system with the new config)
				fn = "custom-system-rebuild";
				# [H]ome rebuild [N]ixos (switch home-manager with the new config)
				hn = "custom-home-rebuild";
			};
		};

		oh-my-posh = {
			enable = true;
			settings = builtins.fromTOML (builtins.unsafeDiscardStringContext (builtins.readFile ./ohmyposh.toml));
		};

		direnv = {
			enable = true;
			nix-direnv.enable = true;
			silent = true;
		};

		zoxide.enable = true;
		fzf.enable = true;
		ripgrep.enable = true;
		eza.enable = true;
		bat.enable = true;
		feh.enable = true;

		tmux = {
			enable = true;
			clock24 = true;
			keyMode = "vi";
			mouse = true;
			baseIndex = 1;
		};
		# zellij = {
		# 	enable = true;
		# 	enableBashIntegration = true;
		# 	settings = {
		# 		theme = lib.mkForce "tokyo-night";
		# 		themes = {
		# 			rose-pine = {
		# 				bg = "#403d52";
		# 				fg = "#e0def4";
		# 				red = "#eb6f92";
		# 				green = "#31748f";
		# 				blue = "#9ccfd8";
		# 				yellow = "#f6c177";
		# 				magenta = "#c4a7e7";
		# 				orange = "#fe640b";
		# 				cyan = "#ebbcba";
		# 				black = "#26233a";
		# 				white = "#e0def4";
		# 			};
		# 		};
		# 		# copy_command = "xclip -selection clipboard";
		# 		copy_command = "wl-copy";
		# 		keybinds = {
		# 			normal = {
		# 				unbind = [ "Ctrl h" "Ctrl s" ];
		# 				"bind \"Ctrl l\"" = { SwitchToMode = "Move"; };
		# 			};
		# 		};
		# 	};
		# };

		git = {
			enable = true;
			userName = "0x1fe1";
			userEmail = "pangolecimal@gmail.com";
			extraConfig = {
				init.defaultBranch = "main";
			};

			aliases = {
				ignore = ''!gi() { curl -sL https://www.toptal.com/developers/gitignore/api/$@ ;}; gi'';
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
	};
}
