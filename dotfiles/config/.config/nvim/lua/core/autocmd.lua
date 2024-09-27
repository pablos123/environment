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
