{ pkgs, ... }@inputs: {
	programs.waybar = {
		enable = true;
		settings = {};
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
				"$mod, Q, exec, wezterm"
				"$mod, F, exec, firefox"
				"$mod, d, exec, dmenu_run"
				"$mod, G, fullscreen"
				"$mod, C, killactive"
				", Print, exec, ${pkgs.grimblast}/bin/grimblast copy area"
				"$mod SHIFT, right, resizeactive, 10 0"
				"$mod SHIFT, left, resizeactive, -10 0"
				"$mod SHIFT, up, resizeactive, 0 -10"
				"$mod SHIFT, down, resizeactive, 0 10"
			] ++ (
				# workspaces
				# binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
				builtins.concatLists (builtins.genList (i:
					let ws = i + 1; in [
					"$mod, code:1${toString i}, workspace, ${toString ws}"
					"$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
				]) 9)
			);
			bindm = [
				"$mod, mouse:272, movewindow"
				"$mod, mouse:273, resizewindow"
			];

			# exec = [ "wlr-randr --output DP-1 --mode 3440x1440@144Hz --adaptive-sync enabled --scale 1.6" ];
			exec-once = [ "waybar" ];
			input = {
				kb_layout = "us,ru";
				kb_options = "grp:caps_toggle";
				follow_mouse = "0";
				accel_profile = "flat";
				# sensitivity = -0.25;
			};

			# 	extraConfig = ''
			# 		decoration:blur:enabled = false
			# 		decoration:drop_shadow = false
			# 		misc:vfr = true
			# 	'';
		};
	};
}
