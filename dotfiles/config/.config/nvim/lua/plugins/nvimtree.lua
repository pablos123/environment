return {
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
        "antosha417/nvim-lsp-file-operations",
        config = function()
            require 'lsp-file-operations'.setup {}
        end,
    },
}
