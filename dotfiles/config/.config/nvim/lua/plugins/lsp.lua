return {
    "nvim-lua/plenary.nvim",
    {
        "neovim/nvim-lspconfig",
        "williamboman/mason-lspconfig.nvim",
        {
            "williamboman/mason.nvim",
            build = function() pcall(vim.cmd, "MasonUpdate") end
        },
        "hrsh7th/nvim-cmp",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "rafamadriz/friendly-snippets",
        "nvimtools/none-ls.nvim",
    }
}
