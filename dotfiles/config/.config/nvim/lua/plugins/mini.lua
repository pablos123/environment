return {
    {
        'echasnovski/mini.nvim',
        version = false,
        config = function()
            require 'mini.icons'.setup {}
            require 'mini.surround'.setup {}
            require 'mini.cursorword'.setup {}
            require 'mini.git'.setup {}
            require 'mini.pick'.setup {}
            local indentscope = require 'mini.indentscope'
            indentscope.setup {
                symbol = '│',
                draw = {
                    delay = 50,
                    animation = indentscope.gen_animation.none(),
                },
            }
            require 'mini.trailspace'.setup {}
            require 'mini.statusline'.setup {}
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
            vim.api.nvim_create_autocmd('BufWritePre', {
                callback = function()
                    MiniTrailspace.trim()
                end
            })
        end,
    },
}
