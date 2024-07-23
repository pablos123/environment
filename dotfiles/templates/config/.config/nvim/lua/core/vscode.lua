vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.undodir = os.getenv("HOME") .. "/.nvim/undodir"
vim.opt.undofile = true
vim.opt.updatetime = 400
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"
vim.opt.completeopt = { "menuone", "noselect", "preview" }
vim.opt.wildmenu = true
vim.opt.hidden = true
vim.opt.wrap = false
vim.opt.timeoutlen = 850
vim.opt.smartindent = true
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.hlsearch = false
vim.opt.ignorecase = true
vim.opt.smartcase = true

local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true, desc = desc }

map("n", "j", "gj", opts)
map("n", "k", "gk", opts)
map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)
map("n", "Y", "y$", opts)
map("n", "n", "nzzzv", opts)
map("n", "N", "Nzzzv", opts)
map("n", "J", "mzJ`z", opts)
map("i", ",", ",<c-g>u", opts)
map("i", ".", ".<c-g>u", opts)
map("i", "!", "!<c-g>u", opts)
map("i", "?", "?<c-g>u", opts)
map("i", ":", ":<c-g>u", opts)
map("v", "//", "y/\\V<c-r>=escape(@\",'/\\')<cr><cr>", opts)
