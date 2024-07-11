local wezterm = require "wezterm"

local config = {}

if wezterm.config_builder then
    config = wezterm.config_builder()
end

config.color_scheme = "COLORSCHEME"
config.colors = { cursor_fg = "black", cursor_bg = "white" }
config.font = wezterm.font("JetBrainsMono Nerd Font")
config.harfbuzz_features = { "calt=0", "clig=0", "liga=0", }
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.scrollback_lines = 5000

-- https://wezfurlong.org/wezterm/config/launch.html#launching-programs
-- wezterm default is a login shell, the shell used is the one defined
-- in your /etc/passwd:
-- The shell will be spawned as -<SHELL> (with a - prefixed to its ARGV0) to invoke it as a login shell.
-- I load all the completions in .profile so I don't want a login shell every time.
-- Just run bash:
config.default_prog = { "/bin/bash" }

local view_img = require "view_img"

config.keys = {
    {
        key = "h",
        mods = "SUPER",
        action = wezterm.action.ActivateTabRelative(-1)
    },
    {
        key = "l",
        mods = "SUPER",
        action = wezterm.action.ActivateTabRelative(1)
    },
    {
        key = "o",
        mods = "SUPER",
        action = wezterm.action.QuickSelectArgs {
            label = "open url",
            patterns = { "https?://\\S+", "www\\.\\S+" },
            action = wezterm.action_callback(function(window, pane)
                local url = window:get_selection_text_for_pane(pane)
                os.execute("chrome " .. url)
            end)
        },
    },
    {
        key = "i",
        mods = "SUPER",
        action = wezterm.action.QuickSelectArgs {
            label = "view image",
            patterns = {
                "https?://\\S+\\.png",
                "https?://\\S+\\.jpg",
                "https?://\\S+\\.jpeg",
                "https?://\\S+\\.webp",
                ".*\\.png",
                ".*\\.jpg",
                ".*\\.jpeg",
                ".*\\.webp",
            },
            action = wezterm.action_callback(view_img.view_img)
        },
    },
}

return config
