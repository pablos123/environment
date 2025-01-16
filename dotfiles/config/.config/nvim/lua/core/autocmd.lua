local create_autocmd = vim.api.nvim_create_autocmd
local c_autogroup = vim.api.nvim_create_augroup('c_autogroup', {})

create_autocmd('FileType', {
    pattern = 'c',
    command = 'setl tabstop=2 shiftwidth=2 softtabstop=2',
    group = c_autogroup
})
