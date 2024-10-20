local wezterm = require('wezterm')

local config = {}

local FONT_ID = 0
local FONTS = {
	"Iosevka",
	"FiraCode Nerd Font",
}
config.font = wezterm.font(FONTS[1])


config.color_scheme = "Tokyo Night"
-- config.disable_default_key_bindings = true
config.adjust_window_size_when_changing_font_size = false
config.warn_about_missing_glyphs = false
config.window_decorations = "NONE | RESIZE"
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false
config.tab_max_width = 64

config.prefer_egl = true
config.front_end = "WebGpu"
config.animation_fps = 1
config.max_fps = 144
config.term = "xterm-256color"

local OPACITY = 0.9
config.window_background_opacity = OPACITY
wezterm.on("toggle-opacity", function(window, _)
	local overrides = window:get_config_overrides() or {}
	if overrides.window_background_opacity == OPACITY then
		overrides.window_background_opacity = 1.0
	else
		overrides.window_background_opacity = OPACITY
	end
	window:set_config_overrides(overrides)
end)

wezterm.on("font-switch", function(window, _)
	local overrides = window:get_config_overrides() or {}
	FONT_ID = (FONT_ID + 1) % #FONTS
	overrides.font = wezterm.font(FONTS[FONT_ID + 1])
	window:set_config_overrides(overrides)
end)

config.keys = {
	{ key = "o", mods = "CTRL|ALT", action = wezterm.action.EmitEvent("toggle-opacity") },
	{ key = "f", mods = "CTRL|ALT", action = wezterm.action.EmitEvent("font-switch") },
	{ key = "h", mods = "CTRL|SHIFT|ALT",
		action = wezterm.action.SplitPane({direction = "Right", size = {Percent = 50}}),
	},
	{ key = "v", mods = "CTRL|SHIFT|ALT",
		action = wezterm.action.SplitPane({direction = "Down", size = {Percent = 50}}),
	},
	{ key = "p", mods = "CTRL", action = wezterm.action.PaneSelect },
	-- { key = "l", mods = "CTRL|SHIFT", action = wezterm.action.nop },
}

return config
