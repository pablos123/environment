return {
    "nvim-lua/plenary.nvim",
    {
      "projekt0n/github-nvim-theme",
      name = "github-theme",
      lazy = false,
      priority = 1000,
      config = function()
        require("github-theme").setup {}
        vim.cmd("colorscheme github_dark_default")
      end,
    },
    {
        "nvim-tree/nvim-tree.lua",
        config = function()
            require("nvim-tree").setup {}
        end,
        keys = {
            { "gt", "<cmd>NvimTreeToggle<cr>", desc = "Open NvimTree" },
        },
    },
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup {}
        end,
    },
}
