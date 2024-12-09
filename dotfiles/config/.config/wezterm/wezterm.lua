local wezterm = require 'wezterm'

local config = {}

if wezterm.config_builder then
    config = wezterm.config_builder()
end

config.color_scheme = 'GitHub Dark'
config.colors = { cursor_fg = 'black', cursor_bg = 'white', cursor_border = 'white' }
config.font = wezterm.font 'JetBrainsMono Nerd Font'
config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0', }
config.scrollback_lines = 10000

-- config.enable_tab_bar = false
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

    -- Workspaces
    { key = 'o', mods = 'SUPER', action = actions.ShowLauncher, },

    -- Tabs
    { key = 't', mods = 'SUPER', action = actions.SpawnTab 'CurrentPaneDomain', },
    { key = 'w', mods = 'SUPER', action = actions.CloseCurrentTab { confirm = true }, },

    { key = 'H', mods = 'SUPER|SHIFT', action = actions.ActivateTabRelative(-1), },
    { key = 'L', mods = 'SUPER|SHIFT', action = actions.ActivateTabRelative(1), },

    { key = '1', mods = 'SUPER', action = actions.ActivateTab(0), },
    { key = '2', mods = 'SUPER', action = actions.ActivateTab(1), },
    { key = '3', mods = 'SUPER', action = actions.ActivateTab(2), },
    { key = '4', mods = 'SUPER', action = actions.ActivateTab(3), },
    { key = '5', mods = 'SUPER', action = actions.ActivateTab(4), },
    { key = '6', mods = 'SUPER', action = actions.ActivateTab(5), },
    { key = '7', mods = 'SUPER', action = actions.ActivateTab(6), },
    { key = '8', mods = 'SUPER', action = actions.ActivateTab(7), },
    { key = '9', mods = 'SUPER', action = actions.ActivateTab(8), },
    { key = '0', mods = 'SUPER', action = actions.ActivateTab(9), },

    {
        key = 'n',
        mods = 'SUPER',
        action = actions.PromptInputLine {
            description = 'Set tab name to:',
            action = wezterm.action_callback(function(window, _, line)
                if line and line ~= '' then
                    window:active_tab():set_title(line)
                end
            end),
        },
    },

    -- Panes
    { key = 'h', mods = 'SUPER', action = actions.ActivatePaneDirection 'Left' },
    { key = 'l', mods = 'SUPER', action = actions.ActivatePaneDirection 'Right' },
    { key = 'k', mods = 'SUPER', action = actions.ActivatePaneDirection 'Up' },
    { key = 'j', mods = 'SUPER', action = actions.ActivatePaneDirection 'Down' },

    { key = '|', mods = 'SUPER|SHIFT', action = actions.SplitHorizontal { domain = "CurrentPaneDomain" }, },
    { key = '_', mods = 'SUPER|SHIFT', action = actions.SplitVertical { domain = "CurrentPaneDomain" }, },

    { key = 'z', mods = 'SUPER', action = actions.TogglePaneZoomState, },
    { key = 'c', mods = 'SUPER', action = actions.CloseCurrentPane { confirm = true }, },

    -- Font size
    { key = '=', mods = 'SUPER', action = actions.IncreaseFontSize, },
    { key = '-', mods = 'SUPER', action = actions.DecreaseFontSize, },

    -- Search
    { key = '/', mods = 'SUPER', action = actions.Search { CaseSensitiveString = "" }, },

    -- Others
    -- Open urls
    {
        key = 'u',
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
    -- All commands
    { key = '?', mods = 'SUPER|SHIFT', action = actions.ActivateCommandPalette, },
}

config.launch_menu = {
    {
        label = 'Devops',
        args = { 'wezterm_template' },
    },
}

return config
