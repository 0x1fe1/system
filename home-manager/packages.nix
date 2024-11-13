{ pkgs, ... }@inputs: {
	home.packages = with pkgs; [
	] ++ [ ### big ahh apps
		# protonvpn-gui
		# staruml
		# vscode
		# bazecor
		blender-hip
		brave
		firefox
		# gimp
		godot_4
		libreoffice
		# vlc
		# postman
		# pgmodeler
	] ++ [ ### cli utils
		acpi
		clipmenu
		coreutils
		fd
		file
		fossil
		sqlite
		jq
		just
		moreutils
		man-pages
		networkmanager
		# ngrok
		playerctl # media
		rlwrap # allows to use arrows in REPLs
		tldr
		universal-ctags
		xclip
		xorg.xbacklight
	] ++ [ ### fonts
		fira-code
		iosevka
		fg-virgil
		noto-fonts-monochrome-emoji
		corefonts
		(nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" "NerdFontsSymbolsOnly" ]; })
	] ++ [ ### window-manager
		wl-clipboard
		wlr-randr
		swww
		# dunst
		# libnotify
		# (pkgs.waybar.overrideAttrs (oldAttrs: {
		#	 mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
		# }))
		# tofi
		# dmenu
		# slurp # screenshot functionality
	] ++ [
		(writeShellScriptBin "custom-nvim" ''
			set -e
			if [[ -e ~/neovim/result/bin/nvim ]]; then
				~/neovim/result/bin/nvim "$@"
			else
				echo "\`nvim\` not found. building..."
				pushd ~/neovim
				nix build && echo "build complete." || echo "build failed."
				popd
			fi
		'')

		(writeShellScriptBin "custom-system-edit" ''
			set -e
			pushd ~/system
			custom-nvim .
			popd
		'')

		# to rebuild boot use:
		# $ NIXOS_INSTALL_BOOTLOADER=1 custom-system-rebuild
		(writeShellScriptBin "custom-system-rebuild" ''
			set -e
			pushd ~/system
			# nh os switch
			if sudo nixos-rebuild switch --flake .#laptop; then
				current=$(nixos-rebuild list-generations --no-build-nix | grep current)
				git add . ; git commit --allow-empty -m "laptop@system: $current"
			fi
			popd
		'')

		(writeShellScriptBin "custom-home-rebuild" ''
			set -e
			pushd ~/system
			# nh home switch --configuration=$(hostname)
			if home-manager switch --flake .#pango@laptop; then
				current=$(nixos-rebuild list-generations --no-build-nix | grep current)
				git add . ; git commit --allow-empty -m "laptop@home: $current"
			fi
			popd
		'')
	];
}
