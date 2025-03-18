return {
    'nvim-lua/plenary.nvim',
    {
        'catppuccin/nvim',
        name = "catppuccin",
        priority = 1000,
        config = function()
            vim.cmd 'colorscheme catppuccin-mocha'
        end
    },
    {
        'pablos123/shellcheck.nvim',
        config = function()
            require 'shellcheck-nvim'.setup {
                shellcheck_options = { '-x', '--enable=all' }
            }
        end
    },
    {
        'stevearc/oil.nvim',
        config = function()
            require 'oil'.setup {
                 view_options = {
                    -- Show files and directories that start with "."
                    show_hidden = true,
                },
                columns = {
                    "icon",
                    "permissions",
                    "size",
                },
                win_options = {
                    number = false,
                    relativenumber = false,
                },
            }

            vim.keymap.set("n", "-", "<cmd>:Oil<cr>", { desc = "Open parent directory" })
        end
    },
}
