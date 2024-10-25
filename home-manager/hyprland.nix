{ pkgs, ... }@inputs: {
	programs.waybar = {
		enable = true;
		settings = {};
	};

	programs.rofi = {
		enable = true;
		terminal = "wezterm";
		theme = "Arc-Dark";
		location = "top";
		package = pkgs.rofi-wayland;
	};

	wayland.windowManager.hyprland = {
		enable = true;
		xwayland.enable = true;
		settings = {
			"$mod" = "SUPER";
			general = {
				gaps_in = 0;
				gaps_out = 0;
				border_size = 0;
			};
			animations.enabled = false;
			bind = [
				"SUPER, T, exec, wezterm"
				"SUPER, D, exec, rofi -show run"
				"SUPER, F, fullscreen"
				"SUPER SHIFT, Q, killactive"
				"SUPER, C, togglefloating"
				"SUPER, W, exec, swww img ~/wallpapers/$(ls ~/wallpapers/ | sort -R | head -1) --transition-type=fade --transition-duration=1"
				", Print, exec, ${pkgs.grimblast}/bin/grimblast copy area"
			] ++ (
				# workspaces
				# binds SUPER + [shift +] {1..9} to [move to] workspace {1..9}
				builtins.concatLists (builtins.genList (i:
					let ws = i + 1; in [
					"SUPER, code:1${toString i}, workspace, ${toString ws}"
					"SUPER SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
				]) 9)
			);
			binde = [
				"SUPER       , left  , movefocus, l"
				"SUPER       , down  , movefocus, d"
				"SUPER       , up    , movefocus, u"
				"SUPER       , right , movefocus, r"
				"SUPER ALT   , left  , resizeactive, -10 0"
				"SUPER ALT   , down  , resizeactive, 0 10"
				"SUPER ALT   , up    , resizeactive, 0 -10"
				"SUPER ALT   , right , resizeactive, 10 0"
				"SUPER SHIFT , left  , movewindow, l"
				"SUPER SHIFT , down  , movewindow, d"
				"SUPER SHIFT , up    , movewindow, u"
				"SUPER SHIFT , right , movewindow, r"
			];
			bindm = [
				"SUPER, mouse:272, movewindow"
				"SUPER, mouse:273, resizewindow"
			];

			# exec = [ "wlr-randr --output DP-1 --mode 3440x1440@144Hz --adaptive-sync enabled --scale 1.6" ];
			exec-once = [ "waybar" "swww-daemon" ];
			input = {
				kb_layout = "us,ru";
				kb_options = "grp:caps_toggle";
				follow_mouse = "0";
				# accel_profile = "flat";
				# sensitivity = -0.25;
			};

			monitor = [
				"eDP-1, 2880x1800@90, 0x0, 2"
			];

			windowrule = [
				"# windowrule = size 50%, ^(EZE)$"
				"windowrule = center, ^(EZE)$"
			];

			xwayland = {
				  force_zero_scaling = true;
			};

			# extraConfig = ''
			# 	# decoration:blur:enabled = false
			# 	# decoration:drop_shadow = false
			# 	# misc:vfr = true
			# '';
		};
	};
}
