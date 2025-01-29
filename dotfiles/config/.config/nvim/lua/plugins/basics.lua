return {
    'nvim-lua/plenary.nvim',
    {
        'RRethy/base16-nvim',
        lazy = false,
        config = function()
            vim.cmd('colorscheme base16-black-metal-dark-funeral')
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
