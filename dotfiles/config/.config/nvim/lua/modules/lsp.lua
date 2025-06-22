return {
    {
        'neovim/nvim-lspconfig',
        config = function()
            require 'lspconfig'.lua_ls.setup {
                on_init = function(client)
                    if client.workspace_folders then
                        local path = client.workspace_folders[1].name
                        if vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc') then
                            return
                        end
                    end

                    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
                        runtime = {
                            version = 'LuaJIT'
                        },
                        workspace = {
                            checkThirdParty = false,
                            library = {
                                vim.env.VIMRUNTIME,
                                '${3rd}/luv/library',
                                '${3rd}/busted/library',
                                vim.api.nvim_get_runtime_file('', true),
                            }
                        }
                    })
                end,
                settings = {
                    Lua = {}
                }
            }

            local language_servers = {
                'pyright',
                'ruff',
                'ts_ls',
                'html',
                'perlnavigator',
                'clangd',
                'texlab',
            }

            for _, ls_name in ipairs(language_servers) do
                require 'lspconfig'[ls_name].setup {}
            end
        end
    },
    {
        'pearofducks/ansible-vim', -- Install Ansible syntax
        lazy = false,              -- Force load
        config = function()
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

            -- Disable auto unindent
            vim.g.ansible_unindent_after_newline = 0

            -- Set dim and more colors
            vim.g.ansible_name_highlight = 'ob'
            vim.g.ansible_extra_keywords_highlight = 1
            vim.g.ansible_attribute_highlight = 'b'

            -- Setup ansiblels if exists. Disable highlight too
            local lspconfig_exists, lspconfig = pcall(require, 'lspconfig')
            if lspconfig_exists and lspconfig.ansiblels then
                lspconfig.ansiblels.setup {
                    on_attach = function(client, _)
                        client.server_capabilities.semanticTokensProvider = nil
                    end
                }
            end

            -- Disable yaml highlight for treesitter if exists
            local treesitter_exists, treesitter_configs = pcall(require, 'nvim-treesitter.configs')
            if treesitter_exists then
                treesitter_configs.setup {
                    highlight = { disable = { 'yaml' }, },
                }
            end
        end,
        ft = 'yaml.ansible',
    },
    {
        'williamboman/mason.nvim',
        config = function()
            require('mason').setup {}
        end
    },
    {
        'MeanderingProgrammer/render-markdown.nvim',
        config = function()
            require 'render-markdown'.setup {}
        end
    },
}
