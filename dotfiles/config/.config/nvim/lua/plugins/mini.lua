return {
    {
        'echasnovski/mini.nvim',
        version = false,
        config = function()
            require 'mini.icons'.setup {}
            require 'mini.surround'.setup {}
            require 'mini.cursorword'.setup {}
            require 'mini.pick'.setup {}
            require 'mini.statusline'.setup {}

            local mini_files = require 'mini.files'
            mini_files.setup {}
            vim.keymap.set("n", "-", function()
                if mini_files.close() then return end

                local buf_name = vim.api.nvim_buf_get_name(0)
                local path = vim.fn.filereadable(buf_name) == 1 and buf_name or vim.fn.getcwd()
                vim.schedule(function()
                    mini_files.open(path)
                    mini_files.reveal_cwd()
                end)
            end, { desc = "Open Mini Files" })

            local indentscope = require 'mini.indentscope'
            indentscope.setup {
                symbol = '│',
                draw = {
                    delay = 50,
                    animation = indentscope.gen_animation.none(),
                },
            }

            local hipatterns = require 'mini.hipatterns'
            hipatterns.setup {
                highlighters = {
                    fixme     = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
                    hack      = { pattern = '%f[%w]()HACK()%f[%W]', group = 'MiniHipatternsHack' },
                    todo      = { pattern = '%f[%w]()TODO()%f[%W]', group = 'MiniHipatternsTodo' },
                    note      = { pattern = '%f[%w]()NOTE()%f[%W]', group = 'MiniHipatternsNote' },
                    hex_color = hipatterns.gen_highlighter.hex_color(),
                },
            }

            require 'mini.move'.setup {
                mappings = {
                    left = '<',
                    right = '>',
                    down = '<C-j>',
                    up = '<C-k>',
                    line_left = '<',
                    line_right = '>',
                    line_down = '<C-j>',
                    line_up = '<C-k>',
                },
            }

            require 'mini.comment'.setup {
                options = {
                    custom_commentstring = function()
                        return require 'ts_context_commentstring.internal'.calculate_commentstring() or
                            vim.bo.commentstring
                    end,
                },
            }

            local mini_trailspace = require 'mini.trailspace'
            mini_trailspace.setup {}
            vim.api.nvim_create_autocmd('BufWritePre', {
                callback = function() mini_trailspace.trim() end
            })
        end,
    },
}
