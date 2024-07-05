local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true, desc = desc }

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
