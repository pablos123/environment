local set_keymap = vim.keymap.set

require 'mini.icons'.setup {}
require 'mini.surround'.setup {}
require 'mini.cursorword'.setup {}
require 'mini.statusline'.setup {}

local mini_pick = require 'mini.pick'
mini_pick.setup {}
set_keymap('n', '<leader>o', function()
    mini_pick.builtin.cli({ command = { 'fd', '--type=f', '--hidden', '--no-follow', '--color=never', '--exclude=.git' } })
end)
set_keymap('n', '<leader>b', function()
    mini_pick.builtin.buffers()
end)

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

require 'mini.comment'.setup {}

local mini_trailspace = require 'mini.trailspace'
mini_trailspace.setup {}
vim.api.nvim_create_autocmd('BufWritePre', {
    callback = function() mini_trailspace.trim() end
})
