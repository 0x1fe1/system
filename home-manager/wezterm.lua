local wezterm = require 'wezterm'
local act = wezterm.action

local config = {}

config.color_scheme = "Tokyo Night"
config.disable_default_key_bindings = true
config.adjust_window_size_when_changing_font_size = false
config.warn_about_missing_glyphs = false
config.window_decorations = "NONE|NONE"
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false
config.tab_max_width = 64

config.enable_wayland = true
config.prefer_egl = true
config.front_end = "WebGpu"
config.animation_fps = 1
config.max_fps = 144
config.term = "xterm-256color"

local OPACITY_ID = 1
local OPACITY_LIST = { 0.0, 0.9, 1.0 }
config.window_background_opacity = OPACITY_LIST[OPACITY_ID + 1]
wezterm.on("toggle-opacity", function(window, _)
	local overrides = window:get_config_overrides() or {}
	overrides.window_background_opacity = OPACITY_LIST[OPACITY_ID + 1]
	OPACITY_ID = (OPACITY_ID + 1) % #OPACITY_LIST
	window:set_config_overrides(overrides)
end)

local FONT_ID = 1
local FONT_LIST = { "Iosevka", "FiraCode Nerd Font" }
config.font = wezterm.font(FONT_LIST[1])
wezterm.on("font-switch", function(window, _)
	local overrides = window:get_config_overrides() or {}
	overrides.font = wezterm.font(FONT_LIST[FONT_ID + 1])
	FONT_ID = (FONT_ID + 1) % #FONT_LIST
	window:set_config_overrides(overrides)
end)

local function keymap(key, mods, action)
	return { key=key, mods=mods, action=action }
end

config.keys = {
	keymap("o", "CTRL|ALT", wezterm.action.EmitEvent("toggle-opacity")),
	keymap("f", "CTRL|ALT", wezterm.action.EmitEvent("font-switch")),
	keymap("v", "CTRL|SHIFT|ALT", wezterm.action.SplitPane({direction = "Right", size = {Percent = 50}})),
	keymap("h", "CTRL|SHIFT|ALT", wezterm.action.SplitPane({direction = "Down", size = {Percent = 50}})),
	keymap("p", "CTRL", wezterm.action.PaneSelect),
	-- keymap("l", "CTRL|SHIFT", wezterm.action.nop),
	keymap('Tab', 'CTRL', act.ActivateTabRelative(1)),
	keymap('Tab', 'SHIFT|CTRL', act.ActivateTabRelative(-1)),
	keymap('[', 'SUPER', act.ActivateTabRelative(-1)),
	keymap(']', 'SUPER', act.ActivateTabRelative(1)),
	keymap('{', 'SHIFT|SUPER', act.MoveTabRelative(-1)),
	keymap('}', 'SHIFT|SUPER', act.MoveTabRelative(1)),
	keymap('+', 'SHIFT|CTRL', act.IncreaseFontSize),
	keymap('=', 'SHIFT|CTRL', act.IncreaseFontSize),
	keymap('-', 'SHIFT|CTRL', act.DecreaseFontSize),
	keymap('_', 'SHIFT|CTRL', act.DecreaseFontSize),
	keymap('c', 'SHIFT|CTRL', act.CopyTo 'Clipboard'),
	-- keymap('f', 'SHIFT|CTRL', act.Search 'CurrentSelectionOrEmptyString'),
	keymap('p', 'SHIFT|CTRL', act.ActivateCommandPalette),
	keymap('r', 'SHIFT|CTRL', act.ReloadConfiguration),
	keymap('t', 'SHIFT|CTRL', act.SpawnTab 'CurrentPaneDomain'),
	keymap('u', 'SHIFT|CTRL', act.CharSelect{ copy_on_select = true, copy_to =  'ClipboardAndPrimarySelection' }),
	keymap('v', 'SHIFT|CTRL', act.PasteFrom 'Clipboard'),
	keymap('w', 'SHIFT|CTRL', act.CloseCurrentTab{ confirm = true }),
	keymap('x', 'SHIFT|CTRL', act.ActivateCopyMode),
	-- keymap('x', 'SHIFT|CTRL', wezterm.action_callback(function (window, pane)
	-- 	window:perform_action(act.CopyMode 'ClearPattern', pane)
	-- 	window:perform_action(act.ActivateCopyMode, pane)
	-- end)),
	keymap('LeftArrow',  'SHIFT|CTRL', act.ActivatePaneDirection 'Left'),
	keymap('RightArrow', 'SHIFT|CTRL', act.ActivatePaneDirection 'Right'),
	keymap('UpArrow',    'SHIFT|CTRL', act.ActivatePaneDirection 'Up'),
	keymap('DownArrow',  'SHIFT|CTRL', act.ActivatePaneDirection 'Down'),

	keymap('LeftArrow',  'SHIFT|ALT|CTRL', act.AdjustPaneSize{ 'Left', 1 }),
	keymap('RightArrow', 'SHIFT|ALT|CTRL', act.AdjustPaneSize{ 'Right', 1 }),
	keymap('UpArrow',    'SHIFT|ALT|CTRL', act.AdjustPaneSize{ 'Up', 1 }),
	keymap('DownArrow',  'SHIFT|ALT|CTRL', act.AdjustPaneSize{ 'Down', 1 }),
}
config.key_tables = {
	copy_mode = {
		{ key = 'Tab', mods = 'NONE', action = act.CopyMode 'MoveForwardWord' },
		{ key = 'Tab', mods = 'SHIFT', action = act.CopyMode 'MoveBackwardWord' },
		{ key = 'Enter', mods = 'NONE', action = act.CopyMode 'MoveToStartOfNextLine' },
		{ key = 'Escape', mods = 'NONE', action = act.Multiple{ 'ScrollToBottom', { CopyMode =  'Close' } } },
		{ key = 'Space', mods = 'NONE', action = act.CopyMode{ SetSelectionMode =  'Cell' } },
		{ key = '$', mods = 'NONE', action = act.CopyMode 'MoveToEndOfLineContent' },
		{ key = '$', mods = 'SHIFT', action = act.CopyMode 'MoveToEndOfLineContent' },
		{ key = ',', mods = 'NONE', action = act.CopyMode 'JumpReverse' },
		{ key = '0', mods = 'NONE', action = act.CopyMode 'MoveToStartOfLine' },
		{ key = ';', mods = 'NONE', action = act.CopyMode 'JumpAgain' },
		{ key = 'F', mods = 'NONE', action = act.CopyMode{ JumpBackward = { prev_char = false } } },
		{ key = 'F', mods = 'SHIFT', action = act.CopyMode{ JumpBackward = { prev_char = false } } },
		{ key = 'G', mods = 'NONE', action = act.CopyMode 'MoveToScrollbackBottom' },
		{ key = 'G', mods = 'SHIFT', action = act.CopyMode 'MoveToScrollbackBottom' },
		{ key = 'H', mods = 'NONE', action = act.CopyMode 'MoveToViewportTop' },
		{ key = 'H', mods = 'SHIFT', action = act.CopyMode 'MoveToViewportTop' },
		{ key = 'L', mods = 'NONE', action = act.CopyMode 'MoveToViewportBottom' },
		{ key = 'L', mods = 'SHIFT', action = act.CopyMode 'MoveToViewportBottom' },
		{ key = 'M', mods = 'NONE', action = act.CopyMode 'MoveToViewportMiddle' },
		{ key = 'M', mods = 'SHIFT', action = act.CopyMode 'MoveToViewportMiddle' },
		{ key = 'O', mods = 'NONE', action = act.CopyMode 'MoveToSelectionOtherEndHoriz' },
		{ key = 'O', mods = 'SHIFT', action = act.CopyMode 'MoveToSelectionOtherEndHoriz' },
		{ key = 'T', mods = 'NONE', action = act.CopyMode{ JumpBackward = { prev_char = true } } },
		{ key = 'T', mods = 'SHIFT', action = act.CopyMode{ JumpBackward = { prev_char = true } } },
		{ key = 'V', mods = 'NONE', action = act.CopyMode{ SetSelectionMode =  'Line' } },
		{ key = 'V', mods = 'SHIFT', action = act.CopyMode{ SetSelectionMode =  'Line' } },
		{ key = '^', mods = 'NONE', action = act.CopyMode 'MoveToStartOfLineContent' },
		{ key = '^', mods = 'SHIFT', action = act.CopyMode 'MoveToStartOfLineContent' },
		{ key = 'b', mods = 'NONE', action = act.CopyMode 'MoveBackwardWord' },
		{ key = 'b', mods = 'ALT', action = act.CopyMode 'MoveBackwardWord' },
		{ key = 'b', mods = 'CTRL', action = act.CopyMode 'PageUp' },
		{ key = 'c', mods = 'CTRL', action = act.Multiple{ 'ScrollToBottom', { CopyMode =  'Close' } } },
		{ key = 'd', mods = 'CTRL', action = act.CopyMode{ MoveByPage = (0.5) } },
		{ key = 'e', mods = 'NONE', action = act.CopyMode 'MoveForwardWordEnd' },
		{ key = 'f', mods = 'NONE', action = act.CopyMode{ JumpForward = { prev_char = false } } },
		{ key = 'f', mods = 'ALT', action = act.CopyMode 'MoveForwardWord' },
		{ key = 'f', mods = 'CTRL', action = act.CopyMode 'PageDown' },
		{ key = 'g', mods = 'NONE', action = act.CopyMode 'MoveToScrollbackTop' },
		{ key = 'g', mods = 'CTRL', action = act.Multiple{ 'ScrollToBottom', { CopyMode =  'Close' } } },
		{ key = 'h', mods = 'NONE', action = act.CopyMode 'MoveLeft' },
		{ key = 'j', mods = 'NONE', action = act.CopyMode 'MoveDown' },
		{ key = 'k', mods = 'NONE', action = act.CopyMode 'MoveUp' },
		{ key = 'l', mods = 'NONE', action = act.CopyMode 'MoveRight' },
		{ key = 'm', mods = 'ALT', action = act.CopyMode 'MoveToStartOfLineContent' },
		{ key = 'o', mods = 'NONE', action = act.CopyMode 'MoveToSelectionOtherEnd' },
		{ key = 'q', mods = 'NONE', action = act.Multiple{ 'ScrollToBottom', { CopyMode =  'Close' } } },
		{ key = 't', mods = 'NONE', action = act.CopyMode{ JumpForward = { prev_char = true } } },
		{ key = 'u', mods = 'CTRL', action = act.CopyMode{ MoveByPage = (-0.5) } },
		{ key = 'v', mods = 'NONE', action = act.CopyMode{ SetSelectionMode =  'Cell' } },
		{ key = 'v', mods = 'CTRL', action = act.CopyMode{ SetSelectionMode =  'Block' } },
		{ key = 'w', mods = 'NONE', action = act.CopyMode 'MoveForwardWord' },
		{ key = 'y', mods = 'NONE', action = act.Multiple{ { CopyTo =  'ClipboardAndPrimarySelection' }, { Multiple = { 'ScrollToBottom', { CopyMode =  'Close' } } } } },
		{ key = 'PageUp', mods = 'NONE', action = act.CopyMode 'PageUp' },
		{ key = 'PageDown', mods = 'NONE', action = act.CopyMode 'PageDown' },
		{ key = 'End', mods = 'NONE', action = act.CopyMode 'MoveToEndOfLineContent' },
		{ key = 'Home', mods = 'NONE', action = act.CopyMode 'MoveToStartOfLine' },
		{ key = 'LeftArrow', mods = 'NONE', action = act.CopyMode 'MoveLeft' },
		{ key = 'LeftArrow', mods = 'ALT', action = act.CopyMode 'MoveBackwardWord' },
		{ key = 'RightArrow', mods = 'NONE', action = act.CopyMode 'MoveRight' },
		{ key = 'RightArrow', mods = 'ALT', action = act.CopyMode 'MoveForwardWord' },
		{ key = 'UpArrow', mods = 'NONE', action = act.CopyMode 'MoveUp' },
		{ key = 'DownArrow', mods = 'NONE', action = act.CopyMode 'MoveDown' },
	},

	search_mode = {
		{ key = 'Enter', mods = 'NONE', action = act.CopyMode 'PriorMatch' },
		{ key = 'Escape', mods = 'NONE', action = act.CopyMode 'Close' },
		{ key = 'n', mods = 'CTRL', action = act.CopyMode 'NextMatch' },
		{ key = 'p', mods = 'CTRL', action = act.CopyMode 'PriorMatch' },
		{ key = 'r', mods = 'CTRL', action = act.CopyMode 'CycleMatchType' },
		{ key = 'u', mods = 'CTRL', action = act.CopyMode 'ClearPattern' },
		{ key = 'PageUp', mods = 'NONE', action = act.CopyMode 'PriorMatchPage' },
		{ key = 'PageDown', mods = 'NONE', action = act.CopyMode 'NextMatchPage' },
		{ key = 'UpArrow', mods = 'NONE', action = act.CopyMode 'PriorMatch' },
		{ key = 'DownArrow', mods = 'NONE', action = act.CopyMode 'NextMatch' },
	},
}

return config
