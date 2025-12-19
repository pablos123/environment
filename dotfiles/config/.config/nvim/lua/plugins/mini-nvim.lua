local keymap_set = vim.keymap.set
local create_autocmd = vim.api.nvim_create_autocmd
local create_augroup = function(name) vim.api.nvim_create_augroup(name, { clear = true }) end

require 'mini.icons'.setup {}
require 'mini.surround'.setup {}
require 'mini.cursorword'.setup {}
require 'mini.statusline'.setup {}

local mini_pick = require 'mini.pick'
mini_pick.setup {}
keymap_set('n', '<leader>o', function()
    mini_pick.builtin.cli({ command = { 'fd', '--type=f', '--hidden', '--no-follow', '--color=never', '--exclude=.git' } })
end)
keymap_set('n', '<leader>b', function()
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
create_autocmd("FileType", {
    desc = "Disable indentscope for certain filetypes",
    pattern = {
        "help",
        "mason",
        "notify",
        "terminal",
        "nofile",
    },
    callback = function()
        vim.b.miniindentscope_disable = true
    end,
    group = create_augroup('no-indentscope-ft'),
})

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
