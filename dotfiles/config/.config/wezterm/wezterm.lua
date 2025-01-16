local wezterm = require 'wezterm'
local mux = wezterm.mux

local config = {}

if wezterm.config_builder then
    config = wezterm.config_builder()
end

config.color_scheme = 'GitHub Dark'
config.colors = { cursor_fg = 'black', cursor_bg = 'white', cursor_border = 'white' }
config.font = wezterm.font 'JetBrainsMono Nerd Font'
config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0', }
config.scrollback_lines = 10000

config.enable_tab_bar = false
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true

config.default_prog = { '/bin/bash' }

config.disable_default_key_bindings = true

local actions = wezterm.action
config.keys = {
    -- Copy|Paste
    { key = 'c', mods = 'CTRL|SHIFT',  action = actions.CopyTo 'Clipboard', },
    { key = 'v', mods = 'CTRL|SHIFT',  action = actions.PasteFrom 'Clipboard', },

    -- Font size
    { key = '=', mods = 'SUPER', action = actions.IncreaseFontSize, },
    { key = '-', mods = 'SUPER', action = actions.DecreaseFontSize, },
}

return config
