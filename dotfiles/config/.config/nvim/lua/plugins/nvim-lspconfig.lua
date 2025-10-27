local language_servers = {
    'ty',
    'ruff',
    'ts_ls',
    'html',
    'perlnavigator',
    'clangd',
    'texlab',
    'lua_ls',
    'ansiblels',
}

vim.lsp.config('lua_ls', {
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
})

vim.lsp.config('ansiblels', {
    on_attach = function(client, _)
        client.server_capabilities.semanticTokensProvider = nil
    end
})

vim.lsp.config('ty', {
    settings = {
        ty = {
            experimental = {
                rename = true,
                autoImport = true,
            },
        },
    },
})

for _, ls_name in ipairs(language_servers) do
    vim.lsp.enable(ls_name)
end
