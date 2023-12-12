return {
    "nvim-lua/plenary.nvim",
    {
        "VonHeikemen/lsp-zero.nvim",
        branch = "v2.x",
        dependencies = {
            -- required
            "neovim/nvim-lspconfig",
            "hrsh7th/nvim-cmp",
            "hrsh7th/cmp-nvim-lsp",
            "L3MON4D3/LuaSnip",
            -- optional
            {
                "williamboman/mason.nvim",
                build = function() pcall(vim.cmd, "MasonUpdate") end
            },
            "williamboman/mason-lspconfig.nvim",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "saadparwaiz1/cmp_luasnip",
            "rafamadriz/friendly-snippets",
        }
    }
}
