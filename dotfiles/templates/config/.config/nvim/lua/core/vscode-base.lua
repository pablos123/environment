local opts = vim.opt

-- handy
opts.backup = false
opts.swapfile = false
opts.undodir = os.getenv("HOME") .. "/.nvim/undodir"
opts.undofile = true
opts.updatetime = 400
opts.mouse = "a"
opts.clipboard = "unnamedplus"
opts.completeopt = { "menuone", "noselect", "preview" }
opts.wildmenu = true
opts.hidden = true
opts.timeoutlen = 850

-- searching
opts.incsearch = true
opts.hlsearch = true
opts.hlsearch = false
opts.ignorecase = true
opts.smartcase = true
