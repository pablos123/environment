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
}
