-- Set .yml and .yaml to yaml.ansible
local create_autocmd = vim.api.nvim_create_autocmd
local ansible_autogroup = vim.api.nvim_create_augroup('ansible_autogroup', { clear = true })

create_autocmd('BufEnter', {
    pattern = { '*.yml', '*.yaml' },
    command = 'setl ft=yaml.ansible',
    group = ansible_autogroup
})
create_autocmd('FileType', {
    pattern = 'yaml.ansible',
    command = 'setl tabstop=2 shiftwidth=2 softtabstop=2',
    group = ansible_autogroup
})

-- Disable auto unindent
vim.g.ansible_unindent_after_newline = 0

-- Set dim and more colors
vim.g.ansible_name_highlight = 'ob'
vim.g.ansible_extra_keywords_highlight = 1
vim.g.ansible_attribute_highlight = 'b'
