{ pkgs, ... }@inputs: {
	programs = {
		wezterm = {
			enable = true;
			extraConfig = builtins.readFile ./wezterm.lua;
		};

		kitty = {
			enable = true;
			themeFile = "tokyo_night_night";
			# themeFile = "rose-pine";
			# extraConfig = builtins.readFile ./kitty.min.conf;
			shellIntegration.enableBashIntegration = true;

			font.name = "Fira Code";
			font.size = 12.0;

			keybindings = {
				"kitty_mod+c"		= "copy_to_clipboard";
				"kitty_mod+v"		= "paste_from_clipboard";
				"kitty_mod+right"	= "next_tab";
				"ctrl+tab"		= "next_tab";
				"kitty_mod+left"	= "previous_tab";
				"ctrl+shift+tab"	= "previous_tab";
				"kitty_mod+t"		= "new_tab";
				"kitty_mod+q"		= "close_tab";
				"kitty_mod+."		= "move_tab_forward";
				"kitty_mod+,"		= "move_tab_backward";
				"kitty_mod+equal"	= "change_font_size all +2.0";
				"kitty_mod+plus"	= "change_font_size all +2.0";
				"kitty_mod+minus"	= "change_font_size all -2.0";
				"kitty_mod+backspace"	= "change_font_size all 0";
				"kitty_mod+e"		= "open_url_with_hints";
				"kitty_mod+u"		= "kitten unicode_input";
				"kitty_mod+a>m"		= "set_background_opacity +0.1";
				"kitty_mod+a>l"		= "set_background_opacity -0.1";
				"kitty_mod+delete"	= "clear_terminal reset active";
			};

			settings = {
				disable_ligatures = "never";
				font_features = "FiraCode-Regular +cv02 +cv25 +cv26 +cv27 +cv28 +cv32 +ss03 +ss05 +ss07 +ss09";
				scrollback_indicator_opacity = "1.0";
				scrollback_pager = "less --chop-long-lines --RAW-CONTROL-CHARS +INPUT_LINE_NUMBER";
				scrollback_pager_history_size = "1";
				wheel_scroll_multiplier = "3.0";
				open_url_with = "firefox";
				enable_audio_bell = "no";
				hide_window_decorations = "yes";
				tab_bar_style = "fade";
				tab_fade = "0.33 0.67 1";
				tab_title_template = "{title}";
				background_opacity = "0.75";
				background_blur = "0";
				dynamic_background_opacity = "yes";
				allow_remote_control = "yes";
				kitty_mod = "ctrl+shift";
				clear_all_shortcuts = "yes";
				shell = "bash";
			};

			extraConfig = ''
				symbol_map U+e000-U+e00a,U+ea60-U+ebeb,U+e0a0-U+e0c8,U+e0ca,U+e0cc-U+e0d4,U+e200-U+e2a9,U+e300-U+e3e3,U+e5fa-U+e6b1,U+e700-U+e7c5,U+f000-U+f2e0,U+f300-U+f372,U+f400-U+f532,U+f0001-U+f1af0 Symbols Nerd Font Mono
				symbol_map U+2300-U+23F3 Noto Emoji'';

		};
	};
}
