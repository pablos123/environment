local opts = vim.opt

-- visuals
opts.termguicolors = true
opts.colorcolumn = { 80, 100, 120 }
opts.signcolumn = "yes"
opts.showmatch = true
opts.number = true
opts.relativenumber = true
opts.cursorline = true
opts.scrolloff = 10
opts.sidescroll = 10

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

-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

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

-- diagnostics
vim.diagnostic.config {
    -- disable underline, it's very annoying
    underline = false,
    -- don't show inline diagnostic
    virtual_text = false
}

-- autocomands
local autocmd = vim.api.nvim_create_autocmd
local au = vim.api.nvim_create_augroup

local file_types_au = au("file_types", {})
autocmd("BufEnter", {
    pattern = "*.yml",
    command = "setl ft=yaml.ansible",
    group = file_types_au
})
autocmd("FileType", {
    pattern = "yaml.ansible",
    command = "setl tabstop=2 shiftwidth=2 softtabstop=2",
    group = file_types_au
})
