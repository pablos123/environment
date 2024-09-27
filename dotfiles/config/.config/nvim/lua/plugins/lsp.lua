return {
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup {}
        end
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            local language_servers = {
                "pyright",
                "ruff_lsp",
                "ansiblels",
                "ts_ls",
                "html",
                "lua_ls",
                "perlnavigator",
            }

            local function setup_server(ls_name)
                require("lspconfig")[ls_name].setup {}
            end

            for _, ls_name in ipairs(language_servers) do
                setup_server(ls_name)
            end
        end
    },
}
