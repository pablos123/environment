local parsers = {
    'bash',
    'c',
    'html',
    'htmldjango',
    'javascript',
    'json',
    'lua',
    'markdown',
    'markdown_inline',
    'perl',
    'python',
    'query',
    'regex',
    'tsx',
    'typescript',
    'vim',
    'yaml',
}

return {
    {
        'nvim-treesitter/nvim-treesitter',
        version = false,
        build = ':TSUpdate',
        cmd = { 'TSUpdateSync', 'TSUpdate', 'TSInstall' },
        event = { 'BufReadPost', 'BufNewFile' },
        config = function()
            vim.g.skip_ts_context_commentstring_module = true
            require 'nvim-treesitter.configs'.setup {
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
                indent = { enable = true },
                ensure_installed = parsers,
            }
        end,
    },
    {
        'JoosepAlviste/nvim-ts-context-commentstring',
        config = function()
            require 'ts_context_commentstring'.setup {
                enable_autocmd = false,
            }
        end
    }
}
