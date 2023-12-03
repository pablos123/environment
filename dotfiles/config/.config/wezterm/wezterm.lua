local wezterm = require "wezterm"

local config = {}

if wezterm.config_builder then
    config = wezterm.config_builder()
end

config.color_scheme = "Gruvbox Material (Gogh)"
config.colors = { cursor_fg = "black", }
config.font = wezterm.font("JetBrainsMono Nerd Font")
config.harfbuzz_features = { "calt=0", "clig=0", "liga=0", }
config.use_fancy_tab_bar = false
config.scrollback_lines = 5000

-- https://wezfurlong.org/wezterm/config/launch.html#launching-programs
-- wezterm default is a login shell, the shell used is the one defined
-- in your /etc/passwd:
-- The shell will be spawned as -<SHELL> (with a - prefixed to its ARGV0) to invoke it as a login shell.
-- I load all the completions in .profile so I don't want a login shell every time.
-- Jus run bash:
config.default_prog = { "/bin/bash" }

local action_functions = require "action_functions"

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
            action = wezterm.action_callback(action_functions.open_url)
        },
    },
    {
        key = "i",
        mods = "SUPER",
        action = wezterm.action.QuickSelectArgs {
            label = "view image",
            patterns = { "https?://\\S+\\.webp", "https?://\\S+\\.jpg", "https?://\\S+\\.png" },
            action = wezterm.action_callback(action_functions.view_img)
        },
    },
}

return config
