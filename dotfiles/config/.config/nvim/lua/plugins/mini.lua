return {
    {
        'echasnovski/mini.nvim',
        version = false,
        config = function()
            require 'mini.icons'.setup {}
            require 'mini.surround'.setup {}
            require 'mini.ai'.setup {}
            require 'mini.cursorword'.setup {}
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
            require 'mini.completion'.setup {
                delay = { completion = 50, info = 50, signature = 25 },
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
                    left = '<C-h>',
                    right = '<C-l>',
                    down = '<C-j>',
                    up = '<C-k>',
                    line_left = '<C-h>',
                    line_right = '<C-l>',
                    line_down = '<C-j>',
                    line_up = '<C-k>',
                },
            }
            require 'mini.comment'.setup {
                options = {
                    custom_commentstring = function()
                        return require 'ts_context_commentstring'.calculate_commentstring() or vim.bo.commentstring
                    end,
                },
            }
            vim.api.nvim_create_autocmd('BufWritePre', {
                desc = 'Clean trail space before saving',
                callback = function()
                    MiniTrailspace.trim()
                end
            })
            vim.keymap.set('i', '<Tab>', [[pumvisible() ? "\<C-n>" : "\<Tab>"]], { expr = true })
            vim.keymap.set('i', '<S-Tab>', [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]], { expr = true })
            local keys = {
                ['cr']        = vim.api.nvim_replace_termcodes('<CR>', true, true, true),
                ['ctrl-y']    = vim.api.nvim_replace_termcodes('<C-y>', true, true, true),
                ['ctrl-y_cr'] = vim.api.nvim_replace_termcodes('<C-y><CR>', true, true, true),
            }

            _G.cr_action = function()
                if vim.fn.pumvisible() ~= 0 then
                    -- If popup is visible, confirm selected item or add new line otherwise
                    local item_selected = vim.fn.complete_info()['selected'] ~= -1
                    return item_selected and keys['ctrl-y'] or keys['ctrl-y_cr']
                else
                    -- If popup is not visible, use plain `<CR>`. You might want to customize
                    -- according to other plugins. For example, to use 'mini.pairs', replace
                    -- next line with `return require('mini.pairs').cr()`
                    return keys['cr']
                end
            end

            vim.keymap.set('i', '<CR>', 'v:lua._G.cr_action()', { expr = true })
        end,
    },
}
