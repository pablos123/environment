local wezterm = require 'wezterm'
local mux = wezterm.mux

local config = {}

if wezterm.config_builder then
    config = wezterm.config_builder()
end

config.color_scheme = 'rose-pine'
-- Black Metal (Burzum) (base16)
config.window_background_opacity = 0.8
config.colors = { cursor_fg = 'black', cursor_bg = 'white', cursor_border = 'white' }
config.font = wezterm.font 'JetBrainsMono Nerd Font'
-- config.font = wezterm.font 'SauceCodePro Nerd Font'
config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0', }
config.scrollback_lines = 10000

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
    { key = 'n', mods = 'SUPER', action = actions.SpawnTab 'CurrentPaneDomain', },
    { key = 'c', mods = 'SUPER', action = actions.CloseCurrentTab { confirm = true }, },

    { key = 'h', mods = 'SUPER', action = actions.ActivateTabRelative(-1), },
    { key = 'l', mods = 'SUPER', action = actions.ActivateTabRelative(1), },

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
        key = 'r',
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
    { key = 'H', mods = 'SUPER|SHIFT', action = actions.ActivatePaneDirection 'Left' },
    { key = 'L', mods = 'SUPER|SHIFT', action = actions.ActivatePaneDirection 'Right' },
    { key = 'K', mods = 'SUPER|SHIFT', action = actions.ActivatePaneDirection 'Up' },
    { key = 'J', mods = 'SUPER|SHIFT', action = actions.ActivatePaneDirection 'Down' },

    { key = '|', mods = 'SUPER|SHIFT', action = actions.SplitHorizontal { domain = "CurrentPaneDomain" }, },
    { key = '_', mods = 'SUPER|SHIFT', action = actions.SplitVertical { domain = "CurrentPaneDomain" }, },

    { key = 'Z', mods = 'SUPER|SHIFT', action = actions.TogglePaneZoomState, },
    { key = 'C', mods = 'SUPER|SHIFT', action = actions.CloseCurrentPane { confirm = true }, },

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

wezterm.on('gui-startup', function(_)
    local first_tab, _, first_window = mux.spawn_window {
        workspace = ' SYSTEM  ',
        args = { 'yazi', '~' },
    }
    first_tab:set_title 'YAZI  '

    local second_tab = first_window:spawn_tab {  args = { 'htop' } }
    second_tab:set_title 'HTOP  '

    local third_tab = first_window:spawn_tab {
        args = { 'nvim', '--cmd', 'cd ~/environment' },
    }
    third_tab:set_title 'DOTFILES  '

    local fourth_tab = first_window:spawn_tab { }
    fourth_tab:set_title 'BASH '

    first_tab:activate {}

    mux.spawn_window { workspace = ' BASH  ' }

    mux.set_active_workspace ' BASH  '
end)

return config
