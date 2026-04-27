-- Faster startup
vim.loader.enable()

-------------------------------------------------------------------------------
-- Definitions
-------------------------------------------------------------------------------
local o = vim.opt
local g = vim.g
local ol = vim.opt_local

local keymap_set = vim.keymap.set
local create_autocmd = vim.api.nvim_create_autocmd
local create_augroup = function(name) vim.api.nvim_create_augroup(name, { clear = true }) end

-------------------------------------------------------------------------------
-- Options
-------------------------------------------------------------------------------
-- Visuals
o.winborder = 'rounded'
o.termguicolors = true
o.colorcolumn = { 80, 100, 120 }
o.signcolumn = 'yes'
o.showmatch = true
o.number = true
o.relativenumber = true
o.cursorline = true
o.scrolloff = 10
o.sidescroll = 10

-- Text display
o.tabstop = 4
o.softtabstop = 4
o.shiftwidth = 4
o.expandtab = true
o.smartindent = true
o.wrap = false

-- Handy
o.backup = false
o.swapfile = false
o.undodir = os.getenv('HOME') .. '/.nvim/undodir'
o.undofile = true
o.updatetime = 400
o.mouse = 'a'
o.wildmenu = true
o.hidden = true
o.timeoutlen = 850
o.completeopt = 'menuone,noinsert'

-- Searching
o.incsearch = true
o.hlsearch = false
o.ignorecase = true
o.smartcase = true

-- Disable Netrw
g.loaded_netrwPlugin = 1
g.loaded_netrw = 1

-- Diagnostics
vim.diagnostic.config {
    underline = false,
    virtual_text = false,
}

-------------------------------------------------------------------------------
-- Keys
-------------------------------------------------------------------------------
-- Leader
keymap_set('', '<space>', '<nop>')
g.mapleader = ' '
g.maplocalleader = ','

-- For wrapped lines
keymap_set('n', 'j', 'gj')
keymap_set('n', 'k', 'gk')

-- Completeness
keymap_set('n', 'Y', 'y$')

-- Keep the cursor in the middle
keymap_set('n', 'n', 'nzzzv')
keymap_set('n', 'N', 'Nzzzv')
keymap_set('n', 'J', 'mzJ`z')

-- Add breakpoints in insert mode
keymap_set('i', ',', ',<c-g>u')
keymap_set('i', '.', '.<c-g>u')
keymap_set('i', '!', '!<c-g>u')
keymap_set('i', '?', '?<c-g>u')
keymap_set('i', ':', ':<c-g>u')

-- Windows
keymap_set('n', '<leader>v', '<c-w>v<c-w>l')
keymap_set('n', '<leader>h', '<c-w>h')
keymap_set('n', '<leader>j', '<c-w>j')
keymap_set('n', '<leader>k', '<c-w>k')
keymap_set('n', '<leader>l', '<c-w>l')

keymap_set('n', '<c-up>', '<cmd>resize +2<cr>')
keymap_set('n', '<c-down>', '<cmd>resize -2<cr>')
keymap_set('n', '_', '<cmd>5winc <<cr>')
keymap_set('n', '+', '<cmd>5winc ><cr>')

-- System clipboard
keymap_set('v', '<leader>y', '"+y')
keymap_set('n', '<leader>Y', '"+y$')
keymap_set('n', '<leader>yy', '"+yy')

keymap_set('v', '<leader>p', '"+p')
keymap_set('v', '<leader>P', '"+P')
keymap_set('n', '<leader>p', '"+p')
keymap_set('n', '<leader>P', '"+P')

-- User friendly
keymap_set('i', '<c-s>', '<cmd>w<cr><esc>')
keymap_set('n', '<c-s>', '<cmd>w<cr><esc>')
keymap_set('v', '<c-s>', '<cmd>w<cr><esc>')
keymap_set('s', '<c-s>', '<cmd>w<cr><esc>')

-- Easily hit escape in terminal mode.
keymap_set('t', '<esc>', '<c-\\><c-n>')

-- Open a terminal at the bottom of the screen with a fixed height.
keymap_set('n', '<leader>t', function()
    vim.cmd.vnew()
    vim.cmd.wincmd 'L'
    vim.api.nvim_win_set_width(0, 40)
    vim.wo.winfixwidth = true
    vim.cmd.term()
    vim.api.nvim_feedkeys('i', 'n', false)
end)

-- Diagnostics
keymap_set('n', 'gd', vim.diagnostic.open_float)

-- Format
keymap_set('n', 'gf', vim.lsp.buf.format)

-- Code action
keymap_set('n', 'ga', vim.lsp.buf.code_action)

-------------------------------------------------------------------------------
-- Autocommands
-------------------------------------------------------------------------------
create_autocmd('FileType', {
    pattern = { 'c', 'html', 'css' },
    command = 'setl tabstop=2 shiftwidth=2 softtabstop=2',
    group = create_augroup('2-indent-ft'),
})

create_autocmd('FileType', {
    pattern = 'markdown',
    callback = function()
        ol.wrap = true
        ol.colorcolumn = {}
        keymap_set('n', 'gf', '<cmd>!mdformat "%"<cr><cr>', { buffer = true })
    end,
    group = create_augroup('clean-markdown'),
})

create_autocmd('TermOpen', {
    callback = function()
        ol.number = false
        ol.relativenumber = false
        ol.scrolloff = 0
        vim.bo.filetype = 'terminal'
    end,
    group = create_augroup('terminal-ft'),
})

-- Ansible: set filetype and indent for yaml files
create_autocmd('BufEnter', {
    pattern = { '*.yml', '*.yaml' },
    command = 'setl ft=yaml.ansible',
    group = create_augroup('ansible-ft'),
})
create_autocmd('FileType', {
    pattern = 'yaml.ansible',
    command = 'setl tabstop=2 shiftwidth=2 softtabstop=2',
    group = create_augroup('ansible-indent'),
})
g.ansible_unindent_after_newline = 0
g.ansible_name_highlight = 'ob'
g.ansible_extra_keywords_highlight = 1
g.ansible_attribute_highlight = 'b'

-------------------------------------------------------------------------------
-- Plugins
-------------------------------------------------------------------------------
-- Bootstrap mini.nvim
local mini_path = vim.fn.stdpath('data') .. '/site/pack/deps/start/mini.nvim'
if not vim.uv.fs_stat(mini_path) then
    vim.cmd('echo "Installing mini.nvim..." | redraw')
    vim.fn.system({ 'git', 'clone', '--filter=blob:none', 'https://github.com/echasnovski/mini.nvim', mini_path })
    vim.cmd('packadd mini.nvim | helptags ALL')
end

-- Bootstrap and load mini.deps for managing non-mini plugins
require('mini.deps').setup {}
MiniDeps.add({ source = 'pablos123/shellcheck.nvim' })
require('shellcheck-nvim').setup {
    shellcheck_options = { '-x', '--enable=all' },
}

-- Icons
require('mini.icons').setup {}

-- Surround
require('mini.surround').setup {}

-- Highlight word under cursor
require('mini.cursorword').setup {}

-- Statusline
require('mini.statusline').setup {}

-- Comment
require('mini.comment').setup {}

-- Notify (replaces noice)
require('mini.notify').setup {}
vim.notify = require('mini.notify').make_notify()

-- Completion (replaces blink.cmp)
require('mini.completion').setup {
    lsp_completion = {
        source_func = 'omnifunc',
        auto_setup = true,
    },
}
-- Use Tab/S-Tab for completion navigation
keymap_set('i', '<Tab>', [[pumvisible() ? "\<C-n>" : "\<Tab>"]], { expr = true })
keymap_set('i', '<S-Tab>', [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]], { expr = true })
keymap_set('i', '<CR>', [[pumvisible() ? "\<C-y>" : "\<CR>"]], { expr = true })
keymap_set('i', '/', [[pumvisible() ? "\<C-y>" : "/\<C-x>\<C-f>"]], { expr = true })
create_autocmd('CompleteDone', {
    callback = function()
        local item = vim.v.completed_item
        if item and item.word and item.word:sub(-1) == '/' then
            vim.schedule(function()
                vim.api.nvim_feedkeys(vim.keycode('<C-x><C-f>'), 'n', false)
            end)
        end
    end,
    group = create_augroup('path-completion-chain'),
})

-- File explorer (replaces netrw)
local mini_files = require('mini.files')
mini_files.setup {}
keymap_set('n', '<leader>e', function()
    if mini_files.close() then return end
    local buf_name = vim.api.nvim_buf_get_name(0)
    local path = vim.fn.filereadable(buf_name) == 1 and buf_name or vim.fn.getcwd()
    vim.schedule(function()
        mini_files.open(path)
        mini_files.reveal_cwd()
    end)
end)

-- Picker (replaces grug-far for search, file finder)
local mini_pick = require('mini.pick')
mini_pick.setup {}
keymap_set('n', '<leader>o', function()
    mini_pick.builtin.cli({ command = { 'fd', '--type=f', '--hidden', '--no-follow', '--color=never', '--exclude=.git' } })
end)
keymap_set('n', '<leader>b', function()
    mini_pick.builtin.buffers()
end)
keymap_set('n', '<leader>s', function()
    mini_pick.builtin.grep_live()
end)

-- Indentscope
local indentscope = require('mini.indentscope')
indentscope.setup {
    symbol = '|',
    draw = {
        delay = 50,
        animation = indentscope.gen_animation.none(),
    },
}
create_autocmd('FileType', {
    pattern = { 'help', 'mason', 'notify', 'terminal', 'nofile' },
    callback = function() vim.b.miniindentscope_disable = true end,
    group = create_augroup('no-indentscope-ft'),
})

-- Highlight patterns (TODO, FIXME, hex colors)
local hipatterns = require('mini.hipatterns')
hipatterns.setup {
    highlighters = {
        fixme     = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
        hack      = { pattern = '%f[%w]()HACK()%f[%W]', group = 'MiniHipatternsHack' },
        todo      = { pattern = '%f[%w]()TODO()%f[%W]', group = 'MiniHipatternsTodo' },
        note      = { pattern = '%f[%w]()NOTE()%f[%W]', group = 'MiniHipatternsNote' },
        hex_color = hipatterns.gen_highlighter.hex_color(),
    },
}

-- Move lines/selections
require('mini.move').setup {
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

-- Trim trailing whitespace on save
local mini_trailspace = require('mini.trailspace')
mini_trailspace.setup {}
create_autocmd('BufWritePre', {
    callback = function() mini_trailspace.trim() end,
})

-- Colorscheme
require('mini.hues').setup { background = '#1a1a2e', foreground = '#d1d1e0' }

-------------------------------------------------------------------------------
-- LSP
-------------------------------------------------------------------------------
local language_servers = {
    'ty',
    'ruff',
    'ts_ls',
    'html',
    'perlnavigator',
    'clangd',
    'texlab',
    'lua_ls',
    'ansiblels',
}

vim.lsp.config('lua_ls', {
    on_init = function(client)
        if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc') then
                return
            end
        end
        client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
            runtime = { version = 'LuaJIT' },
            workspace = {
                checkThirdParty = false,
                library = {
                    vim.env.VIMRUNTIME,
                    '${3rd}/luv/library',
                    '${3rd}/busted/library',
                    vim.api.nvim_get_runtime_file('', true),
                },
            },
        })
    end,
    settings = { Lua = {} },
})

vim.lsp.config('ansiblels', {
    on_attach = function(client, _)
        client.server_capabilities.semanticTokensProvider = nil
    end,
})

vim.lsp.config('ty', {
    settings = {
        ty = {
            experimental = {
                rename = true,
                autoImport = true,
            },
        },
    },
})

for _, ls_name in ipairs(language_servers) do
    vim.lsp.enable(ls_name)
end
