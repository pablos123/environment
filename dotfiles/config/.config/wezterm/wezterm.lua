local wezterm = require 'wezterm'

local config = {}

if wezterm.config_builder then
    config = wezterm.config_builder()
end

config.color_scheme = 'GitHub Dark'
config.colors = { cursor_fg = 'black', cursor_bg = 'white', cursor_border = 'white' }
config.font = wezterm.font 'JetBrainsMono Nerd Font'
config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0', }
config.enable_tab_bar = false
config.scrollback_lines = 10000

config.default_prog = { '/bin/bash' }

config.disable_default_key_bindings = true

local actions = wezterm.action
config.keys = {
    -- Copy|Paste
    { key = 'c', mods = 'CTRL|SHIFT', action = actions.CopyTo 'Clipboard', },
    { key = 'v', mods = 'CTRL|SHIFT', action = actions.PasteFrom 'Clipboard', },

    -- Tabs|Sessions
    { key = 'T', mods = 'SUPER|SHIFT',       action = actions.SpawnTab 'CurrentPaneDomain', },
    { key = 'W', mods = 'SUPER|SHIFT',       action = actions.CloseCurrentTab { confirm = true }, },

    { key = 'O', mods = 'SUPER|SHIFT', action = actions.ShowLauncherArgs { flags = 'TABS' }, },

    { key = 'H', mods = 'SUPER|SHIFT', action = actions.ActivateTabRelative(-1), },
    { key = 'L', mods = 'SUPER|SHIFT', action = actions.ActivateTabRelative(1), },

    -- Panes
    { key = 'h', mods = 'SUPER',      action = actions.ActivatePaneDirection 'Left' },
    { key = 'l', mods = 'SUPER',      action = actions.ActivatePaneDirection 'Right' },
    { key = 'k', mods = 'SUPER',      action = actions.ActivatePaneDirection 'Up' },
    { key = 'j', mods = 'SUPER',      action = actions.ActivatePaneDirection 'Down' },

    { key = 'i', mods = 'SUPER',      action = actions.SplitHorizontal { domain = "CurrentPaneDomain" }, },
    { key = 'u', mods = 'SUPER',      action = actions.SplitVertical { domain = "CurrentPaneDomain" }, },

    { key = 'z', mods = 'SUPER',      action = actions.TogglePaneZoomState, },
    { key = 'c', mods = 'SUPER',      action = actions.CloseCurrentPane { confirm = true }, },

    -- Font size
    { key = '=', mods = 'SUPER', action = actions.IncreaseFontSize, },
    { key = '-', mods = 'SUPER', action = actions.DecreaseFontSize, },

    -- Search
    { key = '/', mods = 'SUPER',       action = actions.Search { CaseSensitiveString = "" }, },

    -- Others
    -- Open urls
    {
        key = 'o',
        mods = 'SUPER',
        action = actions.QuickSelectArgs {
            label = 'open url',
            patterns = { 'https?://\\S+', 'www\\.\\S+' },
            action = wezterm.action_callback(function(window, pane)
                local url = window:get_selection_text_for_pane(pane)
                os.execute('chrome ' .. url)
            end)
        },
    },
    -- Change tab name
    {
        key = 'r',
        mods = 'CTRL|SHIFT',
        action = actions.PromptInputLine {
            description = 'Set name to:',
            action = wezterm.action_callback(function(window, _, line)
                if line and line ~= '' then
                    window:active_tab():set_title(line)
                end
            end),
        },
    },
    -- All commands
    { key = '?', mods = 'SUPER|SHIFT', action = actions.ActivateCommandPalette, },
}

return config
