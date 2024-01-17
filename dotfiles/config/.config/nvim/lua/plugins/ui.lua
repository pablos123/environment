return {
    {
        "sainnhe/gruvbox-material",
        init = function()
            vim.opt.background = "dark"
            vim.g.gruvbox_material_background = "hard"
            vim.g.gruvbox_material_foreground = "material"
            vim.g.gruvbox_material_ui_contrast = "high"
            vim.g.gruvbox_material_enable_bold = 0
            vim.g.gruvbox_material_enable_italic = 1
            vim.g.gruvbox_material_dim_inactive_windows = 1
            vim.g.gruvbox_material_show_eob = 0
            vim.g.gruvbox_material_better_performance = 1
            vim.cmd.colorscheme "gruvbox-material"
        end
    },
    { "nvim-tree/nvim-web-devicons", lazy = true },
    {
        "nvim-lualine/lualine.nvim",
        opts = {
            sections = {
                lualine_a = { "mode" },
                lualine_b = { "branch", "diff" },
                lualine_c = { { "filename", new_file_status = true, path = 1 } },
                lualine_y = { "progress" },
                lualine_z = { "location" }
            },
        }
    },
    {
        "folke/trouble.nvim",
        opts = { use_diagnostic_signs = true },
        keys = {
            { "<leader>di", "<cmd>TroubleToggle<cr>", desc = "Toggle Trouble to view diagnostics" },
        },
    },
}
