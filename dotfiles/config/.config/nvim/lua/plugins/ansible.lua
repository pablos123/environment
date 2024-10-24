-- Set .yml and .yaml to yaml.ansible
local create_autocmd = vim.api.nvim_create_autocmd
local ansible_autogroup = vim.api.nvim_create_augroup('ansible_autogroup', {})

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

return {
    {
        'pearofducks/ansible-vim', -- Install Ansible syntax
        lazy = false, -- Force load
        config = function()
            -- Set dim and more colors
            vim.g.ansible_name_highlight = 'd'
            vim.g.ansible_extra_keywords_highlight = 1
            vim.g.ansible_attribute_highlight = 'a'

            --- Disable highlight for ansiblels if exists
            local lspconfig_status, lspconfig = pcall(require, 'lspconfig')
            if lspconfig_status and lspconfig.ansiblels then
                lspconfig.ansiblels.setup {
                    on_attach = function(client, buffern)
                        client.server_capabilities.semanticTokensProvider = nil
                    end
                }
            end

            --- Disable yaml highlight for treesitter if exists
            local treesitter_status, treesitter = pcall(require, 'nvim-treesitter.configs')
            if treesitter_status then
                require 'nvim-treesitter.configs'.setup {
                    highlight = { disable = { 'yaml' }, },
                }
            end
        end,
        ft = 'yaml.ansible',
    }
}
