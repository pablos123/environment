return {
    {
        'nvim-treesitter/nvim-treesitter',
        version = false,
        build = ':TSUpdate',
        cmd = { 'TSUpdateSync', 'TSUpdate', 'TSInstall' },
        event = { 'BufReadPost', 'BufNewFile' },
        config = function()
            local ensure_installed = {
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

            vim.g.skip_ts_context_commentstring_module = true
            require 'nvim-treesitter.configs'.setup {
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
                indent = { enable = true },
                ensure_installed = ensure_installed,
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
    },
    {
        'nvim-treesitter/nvim-treesitter-context',
        config = function()
            require 'treesitter-context'.setup {
                multiline_threshold = 1,
                max_lines = 4,
                line_numbers = true,
            }
        end
    }
}
