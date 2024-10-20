local wezterm = require 'wezterm';

local config = wezterm.config_builder()

local FONT_ID = 0
local FONTS = {
	"Iosevka",
	"FiraCode Nerd Font",
}
config.font = wezterm.font("Iosevka")


config.color_scheme = "Tokyo Night"
-- config.disable_default_key_bindings = true
config.adjust_window_size_when_changing_font_size = false
config.warn_about_missing_glyphs = false
config.window_decorations = "NONE | RESIZE"
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false

config.prefer_egl = true
config.front_end = "OpenGL"
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
	-- { key = "o", mods = "CTRL|ALT", action = wezterm.action.EmitEvent("toggle-opacity") },
	-- { key = "i", mods = "CTRL|ALT", action = wezterm.action.EmitEvent("font-switch") },
	-- { key = "h", mods = "CTRL|SHIFT|ALT",
	-- 	action = wezterm.action.SplitPane({direction = "Right", size = {Percent = 50}}),
	-- },
	-- { key = "v", mods = "CTRL|SHIFT|ALT",
	-- 	action = wezterm.action.SplitPane({direction = "Down", size = {Percent = 50}}),
	-- },
	-- { key = "u", mods = "CTRL|SHIFT", action = wezterm.action.AdjustPaneSize({"Left", 5})},
	-- { key = "i", mods = "CTRL|SHIFT", action = wezterm.action.AdjustPaneSize({"Down", 5})},
	-- { key = "o", mods = "CTRL|SHIFT", action = wezterm.action.AdjustPaneSize({"Up", 5})},
	-- { key = "p", mods = "CTRL|SHIFT", action = wezterm.action.AdjustPaneSize({"Right", 5})},
	-- { key = "9", mods = "CTRL", action = wezterm.action.PaneSelect },
	-- { key = "l", mods = "CTRL", action = wezterm.action.ShowDebugOverlay },
}

-- config.window_frame = {
-- 	font = wezterm.font("Iosevka"),
-- 	active_titlebar_bg = "#0c0b0f",
-- 	-- active_titlebar_bg = "#181616",
-- }

return config


--------------------------------------------------------------------------------


-- local wezterm = require 'wezterm';
--
-- local config = {}
--
-- local FONT_ID = 0
-- local FONTS = {
--     "FiraCode Nerd Font",
--     "JetBrainsMono Nerd Font",
--     "Noto Emoji",
-- }
--
-- config = {
--     -- color_scheme = "Catppuccin Mocha (Gogh)",
--     -- color_scheme = 'Gruvbox dark, hard (base16)',
--     color_scheme = "Tokyo Night",
--
--     harfbuzz_features = { "cv02", "cv25", "cv26", "cv27", "cv28", "cv32",
--         "ss03", "ss05", "ss07", "ss09" },
--     font = wezterm.font_with_fallback(FONTS),
--
--     adjust_window_size_when_changing_font_size = false,
--     warn_about_missing_glyphs = false,
--     -- disable_default_key_bindings = true,
--     hide_tab_bar_if_only_one_tab = true,
--     window_decorations = "INTEGRATED_BUTTONS|RESIZE",
--     enable_wayland = false,
--
--     -- Backend settings
--     prefer_egl = true,
--     front_end = "WebGpu",
--     webgpu_power_preference = "HighPerformance",
--
--     -- Experimental undocumented features to improve perceived performance
--     -- default delay is 3ms
--     mux_output_parser_coalesce_delay_ms = 1,
--     -- default size is 256
--     glyph_cache_image_cache_size = 512,
--     -- default size is 1024
--     shape_cache_size = 2048,
--     line_state_cache_size = 2048,
--     line_quad_cache_size = 2048,
--     line_to_ele_shape_cache_size = 2048,
--     -- default is 10 fps for animations
--     animation_fps = 60,
--     -- default is 60
--     max_fps = 144,
--
--     -- Set terminal type for better integration
--     term = "wezterm",
-- }
--
-- local opacity = 0.95
-- config.window_background_opacity = opacity
--
-- -- toggle function
-- wezterm.on("toggle-opacity", function(window, _)
--     local overrides = window:get_config_overrides() or {}
--     if not overrides.window_background_opacity then
--         overrides.window_background_opacity = 1.0
--     else
--         overrides.window_background_opacity = nil
--     end
--     window:set_config_overrides(overrides)
-- end)
-- wezterm.on("font-switch", function(window, _)
--     local overrides = window:get_config_overrides() or {}
--     FONT_ID = (FONT_ID + 1) % #FONTS
--     overrides.font = wezterm.font(FONTS[FONT_ID + 1])
--     window:set_config_overrides(overrides)
-- end)
--
-- local function keymap(key, mods, event)
--     return {
--         key = key,
--         mods = mods,
--         action = wezterm.action.EmitEvent(event)
--     }
-- end
--
-- config.keys = {
--     keymap("O", "CTRL", "toggle-opacity"),
--     keymap("I", "CTRL", "font-switch"),
-- }
--
-- return config
