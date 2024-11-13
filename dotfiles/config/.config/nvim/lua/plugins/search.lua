return {
    {
        'nvim-telescope/telescope.nvim',

        branch = '0.1.x',
        keys = {
            { '<leader>o',  '<cmd>lua require("telescope.builtin").find_files()<cr>', desc = 'Find files' },
            { '<leader>f', '<cmd>lua require("telescope.builtin").live_grep()<cr>',  desc = 'Find string' },
            { '<leader>b',  '<cmd>lua require("telescope.builtin").buffers()<cr>',    desc = 'Find buffers' },
        },
        config = function()
            require 'telescope'.setup {
                defaults = {
                    -- lua regex indicating what file to ignore
                    file_ignore_patterns = { '%.git/' },
                    -- Default values except for --hidden
                    vimgrep_arguments = {
                        'rg', '--color=never', '--no-heading', '--with-filename',
                        '--line-number', '--column', '--smart-case', '--no-binary',
                        '--hidden' -- Search also hidden files
                    },
                },
                pickers = {
                    find_files = { theme = 'dropdown', previewer = false, hidden = true },
                    buffers = {
                        theme = 'dropdown',
                        previewer = false,
                        -- Ignore the No Name buffer
                        -- Ignore the buffer opening nvim with 'nvim .'
                        file_ignore_patterns = { '^%[No Name%]$', '^%.$' }
                    }
                },
            }
        end
    },
    {
        'nvim-pack/nvim-spectre',
        config = function()
            require 'spectre'.setup {}
        end,
    },
}
