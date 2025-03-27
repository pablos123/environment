return {
    {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        config = function()
            local telescope = require 'telescope'
            local telescope_builtin = telescope.builtin

            local vimgrep_arguments = { unpack(telescope.config.values.vimgrep_arguments) }
            table.insert(vimgrep_arguments, '--hidden')
            table.insert(vimgrep_arguments, '--fixed-strings')


            local set_keymap = vim.keymap.set
            set_keymap('n', '<leader>o', function () telescope_builtin.find_files() end)
            set_keymap('n', '<leader>f', function () telescope_builtin.live_grep() end)
            set_keymap('n', '<leader>b', function () telescope_builtin.buffers() end)

            telescope.setup {
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
