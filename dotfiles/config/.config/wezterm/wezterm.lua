local wezterm = require 'wezterm'

local config = {}

if wezterm.config_builder then
    config = wezterm.config_builder()
end

config.colors = { cursor_fg = 'black', cursor_bg = 'white', cursor_border = 'white' }
config.font = wezterm.font 'JetBrainsMono Nerd Font'
config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0', }

config.enable_tab_bar = false

config.scrollback_lines = 10000

config.default_prog = { '/bin/bash' }

config.disable_default_key_bindings = true

local actions = wezterm.action
config.keys = {
    { key = 'c', mods = 'CTRL|SHIFT',  action = actions.CopyTo 'Clipboard', },
    { key = 'v', mods = 'CTRL|SHIFT',  action = actions.PasteFrom 'Clipboard', },

    { key = '+', mods = 'CTRL|SHIFT',       action = actions.IncreaseFontSize, },
    { key = '_', mods = 'CTRL|SHIFT',       action = actions.DecreaseFontSize, },
}

return config
