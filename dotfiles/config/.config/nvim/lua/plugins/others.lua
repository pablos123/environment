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
        'nvim-tree/nvim-tree.lua',
        config = function()
            require 'nvim-tree'.setup { actions = { open_file = { window_picker = { enable = false } } } }
        end,
        keys = {
            { '<leader>t', '<cmd>NvimTreeFindFile<cr>', desc = 'Open NvimTree' },
        },
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
      {
    'MagicDuck/grug-far.nvim',
    config = function()
      require('grug-far').setup{}
    end,
    keys = {
        { '<leader>s', '<cmd>GrugFar<cr>', desc = 'Open GrugFar' },
    },
  },
}
