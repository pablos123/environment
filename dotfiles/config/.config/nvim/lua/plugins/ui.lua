return {

    -- theme
    {
        "sainnhe/gruvbox-material",
        init = function()
            vim.opt.background = "dark"
            vim.g.gruvbox_material_background = "hard"
            vim.g.gruvbox_material_foreground = "mix"
            vim.g.gruvbox_material_enable_bold = 1
            vim.g.gruvbox_material_enable_italic = 1
            vim.g.gruvbox_material_dim_inactive_windows = 1
            vim.g.gruvbox_material_ui_contrast = 1
            vim.g.gruvbox_material_better_performance = 1
            vim.cmd.colorscheme "gruvbox-material"
        end
    },

    -- Ansible highlight
    { "pearofducks/ansible-vim" },

    -- icons
    { "nvim-tree/nvim-web-devicons", lazy = true },

    -- greeter
    {
        "goolord/alpha-nvim",
        event = "VimEnter",
        init = function()
            local alpha = require "alpha"
            local dashboard = require "alpha.themes.dashboard"

            -- Set header
            dashboard.section.header.val = { "🍂" }

            -- Set menu
            dashboard.section.buttons.val = {
                dashboard.button("<spc>o", "  > open file", "<cmd>Telescope find_files<cr>"),
                dashboard.button("w", "  > workspaces", "<cmd>Telescope workspaces<cr>"),
                dashboard.button("l", "  > lazy", "<cmd>Lazy<cr>"),
                dashboard.button("m", "  > mason", "<cmd>Mason<cr>"),
                dashboard.button("h", "  > health", "<cmd>checkhealth<cr>"),
                dashboard.button("s", "  > settings", "<cmd>e $MYVIMRC | :cd %:p:h<cr>"),
                dashboard.button("q", "󰠜  > quit", "<cmd>qa!<cr>")
            }

            -- Send config to alpha
            alpha.setup(dashboard.opts)
        end,
    },

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

    -- indent guides
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      indent = {
        char = "│",
        tab_char = "│",
      },
      scope = { enabled = false },
      exclude = {
        filetypes = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "lazyterm",
        },
      },
    },
    main = "ibl",
  },

    -- better vim.ui
    {
        "stevearc/dressing.nvim",
        lazy = true,
        init = function()
            vim.ui.select = function(...)
                require "lazy".load({ plugins = { "dressing.nvim" } })
                return vim.ui.select(...)
            end
            vim.ui.input = function(...)
                require "lazy".load({ plugins = { "dressing.nvim" } })
                return vim.ui.input(...)
            end
        end,
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
