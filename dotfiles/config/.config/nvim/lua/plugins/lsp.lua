return {
    "nvim-lua/plenary.nvim",
    {
        "neovim/nvim-lspconfig",
        "williamboman/mason-lspconfig.nvim",
        {
            "williamboman/mason.nvim",
            build = function() pcall(vim.cmd, "MasonUpdate") end
        },
        "nvimtools/none-ls.nvim",
    }
}
