local opts = vim.opt

-- visuals
opts.termguicolors = true
opts.colorcolumn = { 80, 100, 120 }
opts.signcolumn = 'yes'
opts.showmatch = true
opts.number = true
opts.relativenumber = true
opts.cursorline = true
opts.scrolloff = 10
opts.sidescroll = 10
vim.cmd('colorscheme murphy')

-- text display
opts.tabstop = 4
opts.softtabstop = 4
opts.shiftwidth = 4
opts.expandtab = true
opts.smartindent = true
opts.wrap = false

-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- diagnostics
vim.diagnostic.config {
    -- disable underline, it's very annoying
    underline = false,
    -- don't show inline diagnostic
    virtual_text = false
}

-- handy
opts.backup = false
opts.swapfile = false
opts.undodir = os.getenv('HOME') .. '/.nvim/undodir'
opts.undofile = true
opts.updatetime = 400
opts.mouse = 'a'
opts.wildmenu = true
opts.hidden = true
opts.timeoutlen = 850

-- searching
opts.incsearch = true
opts.hlsearch = true
opts.hlsearch = false
opts.ignorecase = true
opts.smartcase = true
