return {
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup {}
        end
    },
    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup {}
        end
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            require("lspconfig").ansiblels.setup {}
            require("lspconfig").ts_ls.setup {}
            require("lspconfig").ruff_lsp.setup {}
        end
    },
}
