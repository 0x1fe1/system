{ pkgs, ... }@inputs: {
	home.packages = with pkgs; [
		### big ahh apps
		# protonvpn-gui
		# staruml
		# vlc
		# vscode
		bazecor
		blender-hip
		brave
		cool-retro-term
		firefox
		floorp
		gimp
		kdePackages.kate
		libreoffice
		obsidian
		pgmodeler
		vlc

		### cli utils
		# nix-prefetch
		# nix-prefetch-github
		# qemu
		# quickemu
		clipmenu
		fd
		file
		fossil
		jq
		just
		maim # screenshot
		networkmanager
		networkmanagerapplet
		ngrok
		playerctl # media
		rlwrap # allows to use arrows in REPLs
		tldr
		universal-ctags
		wgo
		xclip
		xorg.xbacklight # screen brightness
		xorg.xf86inputsynaptics # touchpad

		### fonts
		fira-code
		fg-virgil
		noto-fonts-monochrome-emoji
		corefonts
		(nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" "NerdFontsSymbolsOnly" ]; })

		### hyprland
		wl-clipboard
		wlr-randr
		# dunst
		# libnotify
		# swww
		# (pkgs.waybar.overrideAttrs (oldAttrs: {
		#	 mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
		# }))
		# networkmanagerapplet
		# rofi-wayland
		# tofi
		dmenu
		# grim # screenshot functionality
		# slurp # screenshot functionality
		catppuccin-cursors.mochaDark
	] ++ [
		(writeShellScriptBin "custom-system-edit" ''
			set -e
			pushd ~/system
			nix run ~/neovim .
			popd
		'')

		# to rebuild boot use:
		# $ NIXOS_INSTALL_BOOTLOADER=1 custom-system-rebuild
		(writeShellScriptBin "custom-system-rebuild" ''
			set -e
			pushd ~/system
			# nh os switch
			if sudo nixos-rebuild switch --flake .#desktop; then
				current=$(nixos-rebuild list-generations --no-build-nix | grep current)
				git add . ; git commit --allow-empty -m "desktop@system: $current"
			fi
			popd
		'')

		(writeShellScriptBin "custom-home-rebuild" ''
			set -e
			pushd ~/system
			# nh home switch --configuration=$(hostname)
			if home-manager switch --flake .#pango@desktop; then
				current=$(nixos-rebuild list-generations --no-build-nix | grep current)
				git add . ; git commit --allow-empty -m "desktop@home: $current"
			fi
			popd
		'')
	];
}
