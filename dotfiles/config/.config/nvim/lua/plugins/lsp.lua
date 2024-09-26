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
            require("lspconfig").bashls.setup {}
            require("lspconfig").ansiblels.setup {}
        end
    },
}
