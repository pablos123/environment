return {
    {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        keys = {
            { '<leader>o', '<cmd>lua require("telescope.builtin").find_files()<cr>', desc = 'Find files' },
            { '<leader>f', '<cmd>lua require("telescope.builtin").live_grep()<cr>',  desc = 'Find string' },
            { '<leader>b', '<cmd>lua require("telescope.builtin").buffers()<cr>',    desc = 'Find buffers' },
        },
        config = function()
            local telescopeConfig = require("telescope.config")

            local vimgrep_arguments = { unpack(telescopeConfig.values.vimgrep_arguments) }
            table.insert(vimgrep_arguments, "--hidden")
            table.insert(vimgrep_arguments, "--fixed-strings")

            require 'telescope'.setup {
                defaults = {
                    file_ignore_patterns = { '%.git/' },
                    vimgrep_arguments = vimgrep_arguments,
                },
                pickers = {
                    find_files = {
                        theme = 'dropdown',
                        previewer = false,
                        hidden = true,
                    },
                    buffers = {
                        theme = 'dropdown',
                        previewer = false,
                        file_ignore_patterns = { '^%[No Name%]$', '^%.$' }
                    }
                },
            }
        end
    },
    'nvim-lua/plenary.nvim',
}
