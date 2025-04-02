return {
    {
        'pablos123/shellcheck.nvim',
        config = function()
            require 'shellcheck-nvim'.setup {
                shellcheck_options = { '-x', '--enable=all' }
            }
        end
    },
    {
        'pablos123/present.nvim',
        config = function() require 'present-nvim'.setup {} end
    },
}
