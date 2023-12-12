return {

    -- theme
    {
        "sainnhe/gruvbox-material",
        init = function()
            vim.opt.background = "dark"
            vim.g.gruvbox_material_background = "hard"
            vim.g.gruvbox_material_foreground = "material"
            vim.g.gruvbox_material_ui_contrast = "high"
            vim.g.gruvbox_material_enable_bold = 0
            vim.g.gruvbox_material_enable_italic = 1
            vim.g.gruvbox_material_dim_inactive_windows = 1
            vim.g.gruvbox_material_show_eob = 0
            vim.g.gruvbox_material_better_performance = 1
            vim.cmd.colorscheme "gruvbox-material"
        end
    },

    -- Ansible highlight
    { "pearofducks/ansible-vim" },

    -- icons
    { "nvim-tree/nvim-web-devicons", lazy = true },

    -- status line
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        opts = {
            sections = {
                lualine_a = { "mode" },
                lualine_b = { "branch", "diff" },
                lualine_c = { { "filename", new_file_status = true, path = 1 } },
                lualine_y = { "progress" },
                lualine_z = { "location" }
            },
        }
    },

    -- highlight current indent
    {
        "echasnovski/mini.indentscope",
        version = false, -- wait till new 0.7.0 release to put it back on semver
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            symbol = "│",
            options = { try_as_border = true },
        },
        init = function()
            vim.api.nvim_create_autocmd("FileType", {
                pattern = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy", "mason" },
                callback = function()
                    vim.b.miniindentscope_disable = true
                end,
            })
        end,
        config = function(_, options)
            require "mini.indentscope".setup(options)
        end,
    },

    -- highlight trailspace
    {
        'echasnovski/mini.trailspace',
        version = false,
        config = function(_, options)
            require "mini.trailspace".setup(options)
        end,
    },

    -- highlight all ocurrencies of word under cursor
    {
        'echasnovski/mini.cursorword',
        version = false,
        config = function(_, options)
            require "mini.cursorword".setup(options)
        end,
    },
}
