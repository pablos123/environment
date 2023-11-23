return {

    -- file explorer
    {
        "nvim-neo-tree/neo-tree.nvim",
        dependencies = { "MunifTanjim/nui.nvim", },
        keys = {
            {
                "<leader>ft", "<cmd>Neotree toggle<cr>"
            },
        },
        opts = {
            enable_git_status = true,
            enable_diagnostics = true,
            filesystem = {
                bind_to_cwd = false,
                follow_current_file = true,
            },
            window = {
                mappings = {
                    ["<space>"] = "none",
                },
            },
            default_component_configs = {
                indent = {
                    with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
                    expander_collapsed = "",
                    expander_expanded = "",
                    expander_highlight = "NeoTreeExpander",
                },
            },
        },
    },

    -- git signs
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
        },
        keys = {
            { "<leader>gl", "<cmd>Gitsigns toggle_current_line_blame<cr>", desc = "Toggle author line" },
        },
    },

    -- better diagnostics list and others
    {
        "folke/trouble.nvim",
        opts = { use_diagnostic_signs = true },
        keys = {
            { "<leader>di", "<cmd>TroubleToggle<cr>", desc = "Toggle Trouble to view diagnostics" },
        },
    },

    -- workspaces
    {
        "natecraddock/workspaces.nvim",
        version = false,
        lazy = true,
        config = function(_, options)
            require "workspaces".setup(options)
        end,
        init = function()
            require "telescope".load_extension("workspaces")
        end,
    },

    -- live colors
    {
        "NvChad/nvim-colorizer.lua",
        version = false,
        config = function(_, options)
            require "colorizer".setup(options)
        end,
    },

    -- move text chunks
    {
        'echasnovski/mini.move',
        version = false,
        config = function(_, _)
            local options = {
                mappings = {
                    left = '<C-h>',
                    right = '<C-l>',
                    down = '<C-j>',
                    up = '<C-k>',
                    line_left = '<C-h>',
                    line_right = '<C-l>',
                    line_down = '<C-j>',
                    line_up = '<C-k>',
                },
            }
            require "mini.move".setup(options)
        end,
    },
}