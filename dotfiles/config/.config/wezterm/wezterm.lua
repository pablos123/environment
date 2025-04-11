local wezterm = require 'wezterm'

local config = {}

if wezterm.config_builder then
    config = wezterm.config_builder()
end

config.color_scheme = 'Catppuccin Mocha'
config.colors = { cursor_fg = 'black', cursor_bg = 'white', cursor_border = 'white' }
config.font = wezterm.font 'JetBrainsMono Nerd Font'

-- Going to test ligatures for a while
-- config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0', }

config.enable_tab_bar = true
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.show_new_tab_button_in_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true

config.scrollback_lines = 10000

-- Don't make a login shell every time
config.default_prog = { '/bin/bash' }

config.disable_default_key_bindings = true

local actions = wezterm.action
config.keys = {
    { key = 'C', mods = 'CTRL|SHIFT', action = actions.CopyTo 'Clipboard', },
    { key = 'V', mods = 'CTRL|SHIFT', action = actions.PasteFrom 'Clipboard', },

    { key = '+', mods = 'CTRL|SHIFT', action = actions.IncreaseFontSize, },
    { key = '_', mods = 'CTRL|SHIFT', action = actions.DecreaseFontSize, },

    { key = 'T', mods = 'CTRL|SHIFT', action = actions.SpawnTab 'CurrentPaneDomain', },
    { key = 'W', mods = 'CTRL|SHIFT', action = actions.CloseCurrentTab { confirm = true }, },
    { key = 'P', mods = 'CTRL|SHIFT', action = actions.ActivateTabRelative(-1) },
    { key = 'N', mods = 'CTRL|SHIFT', action = actions.ActivateTabRelative(1) },
}

return config
