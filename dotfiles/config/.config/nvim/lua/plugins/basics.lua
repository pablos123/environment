return {
    'nvim-lua/plenary.nvim',
    {
        'lewis6991/gitsigns.nvim',
        config = function()
            require 'gitsigns'.setup {}
        end,
    },
    {
        'pablos123/shellcheck.nvim',
        config = function()
            require 'shellcheck-nvim'.setup {
                extras = { '-x', '--enable=all' }
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
