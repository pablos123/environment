return {
    'nvim-lua/plenary.nvim',
    {
        'projekt0n/github-nvim-theme',
        name = 'github-theme',
        lazy = false,
        priority = 1000,
        config = function()
            require 'github-theme'.setup {}
            vim.cmd('colorscheme github_dark_default')
        end,
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
