return {
    {
        'williamboman/mason.nvim',
        config = function()
            require('mason').setup {}
        end
    },
    {
        'neovim/nvim-lspconfig',
        config = function()
            -- lua_ls for neovim
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
                            -- Tell the language server which version of Lua you're using
                            -- (most likely LuaJIT in the case of Neovim)
                            version = 'LuaJIT'
                        },
                        -- Make the server aware of Neovim runtime files
                        workspace = {
                            checkThirdParty = false,
                            library = {
                                vim.env.VIMRUNTIME,
                                '${3rd}/luv/library',
                                -- '${3rd}/busted/library',
                            }
                            -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
                            -- library = vim.api.nvim_get_runtime_file('', true)
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
            }

            local function setup_server(ls_name)
                require 'lspconfig'[ls_name].setup {}
            end

            for _, ls_name in ipairs(language_servers) do
                setup_server(ls_name)
            end
        end
    },
}
