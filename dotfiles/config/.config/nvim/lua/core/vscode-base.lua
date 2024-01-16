local opts = vim.opt

-- visuals
opts.signcolumn = "yes"
opts.showmatch = true
opts.cursorline = true
opts.scrolloff = 10
opts.sidescroll = 10

-- handy
opts.backup = false
opts.swapfile = false
opts.updatetime = 400
opts.mouse = "a"
opts.clipboard = "unnamedplus"
opts.hidden = true
opts.timeoutlen = 850

-- searching
opts.incsearch = true
opts.hlsearch = true
opts.hlsearch = false
opts.ignorecase = true
opts.smartcase = true

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

