local opts = vim.opt
local set_keymap = vim.keymap.set
local create_autocmd = vim.api.nvim_create_autocmd

-- Visuals
opts.termguicolors = true
opts.colorcolumn = { 80, 100, 120 }
opts.signcolumn = 'yes'
opts.showmatch = true
opts.number = true
opts.relativenumber = true
opts.cursorline = true
opts.scrolloff = 10
opts.sidescroll = 10

-- Text display
opts.tabstop = 4
opts.softtabstop = 4
opts.shiftwidth = 4
opts.expandtab = true
opts.smartindent = true
opts.wrap = false

-- Disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Diagnostics
vim.diagnostic.config {
    -- Disable underline
    underline = false,
    -- Don't show inline diagnostic
    virtual_text = false
}

-- Handy
opts.backup = false
opts.swapfile = false
opts.undodir = os.getenv('HOME') .. '/.nvim/undodir'
opts.undofile = true
opts.updatetime = 400
opts.mouse = 'a'
opts.wildmenu = true
opts.hidden = true
opts.timeoutlen = 850

-- Searching
opts.incsearch = true
opts.hlsearch = true
opts.hlsearch = false
opts.ignorecase = true
opts.smartcase = true

-- Leader
set_keymap('', '<space>', '<nop>')
vim.g.mapleader = ' '
vim.g.maplocalleader = ','

-- For wrapped lines
set_keymap('n', 'j', 'gj')
set_keymap('n', 'k', 'gk')

-- Completeness
set_keymap('n', 'Y', 'y$')

-- Keep the cursor in the middle
set_keymap('n', 'n', 'nzzzv')
set_keymap('n', 'N', 'Nzzzv')
set_keymap('n', 'J', 'mzJ`z')

-- Add breakpoints in isert mode
set_keymap('i', ',', ',<c-g>u')
set_keymap('i', '.', '.<c-g>u')
set_keymap('i', '!', '!<c-g>u')
set_keymap('i', '?', '?<c-g>u')
set_keymap('i', ':', ':<c-g>u')

-- Windows
set_keymap('n', '<leader>v', '<c-w>v<c-w>l')
set_keymap('n', '<leader>h', '<c-w>h')
set_keymap('n', '<leader>j', '<c-w>j')
set_keymap('n', '<leader>k', '<c-w>k')
set_keymap('n', '<leader>l', '<c-w>l')

set_keymap('n', '<c-up>', '<cmd>resize +2<cr>')
set_keymap('n', '<c-down>', '<cmd>resize -2<cr>')
set_keymap('n', '_', '<cmd>5winc <<cr>')
set_keymap('n', '+', '<cmd>5winc ><cr>')

-- System clipboard
set_keymap('v', '<leader>y', '"+y')
set_keymap('n', '<leader>Y', '"+y$')
set_keymap('n', '<leader>yy', '"+yy')

set_keymap('v', '<leader>p', '"+p')
set_keymap('v', '<leader>P', '"+P')
set_keymap('n', '<leader>p', '"+p')
set_keymap('n', '<leader>P', '"+P')

-- User friendly
set_keymap('i', '<c-s>', '<cmd>w<cr><esc>')
set_keymap('n', '<c-s>', '<cmd>w<cr><esc>')
set_keymap('v', '<c-s>', '<cmd>w<cr><esc>')
set_keymap('s', '<c-s>', '<cmd>w<cr><esc>')

create_autocmd('FileType', {
    pattern = 'c',
    command = 'setl tabstop=2 shiftwidth=2 softtabstop=2',
    group = vim.api.nvim_create_augroup('c-indent', {}),
})

-- Set local settings for terminal buffers
create_autocmd("TermOpen", {
    group = vim.api.nvim_create_augroup("custom-term-open", {}),
    callback = function()
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
        vim.opt_local.scrolloff = 0

        vim.bo.filetype = "terminal"
    end,
})

-- Easily hit escape in terminal mode.
set_keymap('t', '<esc>', '<c-\\><c-n>')

-- Open a terminal at the bottom of the screen with a fixed height.
set_keymap('n', 'gt', function()
    vim.cmd.new()
    vim.cmd.wincmd 'J'
    vim.api.nvim_win_set_height(0, 12)
    vim.wo.winfixheight = true
    vim.cmd.term()
    vim.api.nvim_feedkeys('i', 'n', false)
end)

set_keymap('n', 'gd', function() vim.diagnostic.open_float() end)

-- This overwrites 'goto files' I do not use it.
set_keymap('n', 'gf', function() vim.lsp.buf.format() end)

return {
    {
        "ellisonleao/gruvbox.nvim",
        priority = 1000,
        config = function()
            vim.cmd 'set background=dark'
            vim.cmd 'colorscheme gruvbox'
        end
    },

    {
        'catppuccin/nvim',
        name = "catppuccin",
        priority = 1000,
        -- config = function() vim.cmd 'colorscheme catppuccin-mocha' end
    },
}
