local wezterm = require "wezterm"

local config = {}

if wezterm.config_builder then
    config = wezterm.config_builder()
end

config.color_scheme = "GitHub Dark"
config.colors = { cursor_fg = "black", cursor_bg = "white", cursor_border = "white" }
config.font = wezterm.font("JetBrainsMono Nerd Font")
config.harfbuzz_features = { "calt=0", "clig=0", "liga=0", }
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.scrollback_lines = 10000

-- https://wezfurlong.org/wezterm/config/launch.html#launching-programs
-- wezterm default is a login shell, the shell used is the one defined
-- in your /etc/passwd:
-- The shell will be spawned as -<SHELL> (with a - prefixed to its ARGV0) to invoke it as a login shell.
-- I load all the completions in .profile so I don't want a login shell every time.
-- Just run bash:
config.default_prog = { "/bin/bash" }


config.disable_default_mouse_bindings = true
config.disable_default_key_bindings = true
config.keys = {
    {
      key = 'p',
      mods = 'SUPER',
      action = wezterm.action.ActivateCommandPalette,
    },
    -- {
    --   key = 'c',
    --   mods = 'CTRL|SHIFT',
    --   action = wezterm.action.CopyTo "Clipboard",
    -- },
    -- {
    --   key = 'v',
    --   mods = 'CTRL|SHIFT',
    --   action = wezterm.action.PasteFrom "Clipboard",
    -- },
    {
      key = '=',
      mods = 'SUPER',
      action = wezterm.action.IncreaseFontSize,
    },
    {
      key = '-',
      mods = 'SUPER',
      action = wezterm.action.DecreaseFontSize,
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
}

return config
