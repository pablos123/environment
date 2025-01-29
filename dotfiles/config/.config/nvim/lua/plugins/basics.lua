return {
    'nvim-lua/plenary.nvim',
    {
        "rose-pine/neovim",
        lazy = false,
        name = "rose-pine",
        config = function()
            vim.cmd("colorscheme rose-pine")
        end
    },
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
}
