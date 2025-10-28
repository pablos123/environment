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

local function add_plugin(repo)
    local repo_split = {} -- author/name
    for str in string.gmatch(repo, '([^/]+)') do table.insert(repo_split, str) end

    local m_name = 'plugins.' .. string.gsub(repo_split[2], '%.', '-')

    vim.pack.add({ { src = 'https://github.com/' .. repo }, })
    pcall(require, m_name)
end

local plugins = {
    'rafamadriz/friendly-snippets',
    'saghen/blink.cmp',
    'neovim/nvim-lspconfig',
    'williamboman/mason.nvim',
    'MagicDuck/grug-far.nvim',
    'pearofducks/ansible-vim',
    'pablos123/shellcheck.nvim',
    'echasnovski/mini.nvim',
}

-------------------------------------------------------------------------------
-- Options
-------------------------------------------------------------------------------
-- Visuals
vim.cmd 'set background=dark'
vim.cmd 'colorscheme wildcharm'
o.winborder = 'rounded'
o.pumborder = 'rounded'

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

-- Searching
o.incsearch = true
o.hlsearch = true
o.hlsearch = false
o.ignorecase = true
o.smartcase = true

-- Netrw
g.netrw_keepdir = 0
g.netrw_winsize = 30
g.netrw_banner = 0
g.netrw_localcopydircmd = 'cp -r'
g.netrw_liststyle = 3
g.netrw_bufsettings = 'noma nomod nu rnu nobl nowrap ro'

-- Diagnostics
vim.diagnostic.config {
    -- Disable underline
    underline = false,
    -- Don't show inline diagnostic
    virtual_text = false
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

-- Add breakpoints in isert mode
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

-- This overwrites 'goto files' I do not use it.
keymap_set('n', 'gf', vim.lsp.buf.format)

-- This overwrites 'goto files' I do not use it.
keymap_set('n', 'ga', vim.lsp.buf.code_action)

-- Explore files
keymap_set('n', '<leader>e', '<cmd>Lexplore<cr><esc>')

-------------------------------------------------------------------------------
-- Autocommands Autogroups
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

-- Set local settings for terminal buffers
create_autocmd('TermOpen', {
    callback = function()
        ol.number = false
        ol.relativenumber = false
        ol.scrolloff = 0

        vim.bo.filetype = 'terminal'
    end,
    group = create_augroup('terminal-ft'),
})

-------------------------------------------------------------------------------
-- Plugins
-------------------------------------------------------------------------------
for _, p in ipairs(plugins) do add_plugin(p) end
