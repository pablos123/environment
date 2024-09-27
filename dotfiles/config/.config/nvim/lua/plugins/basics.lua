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
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        opts = {
            defaults = {
                -- lua regex indicating what file to ignore
                file_ignore_patterns = { "%.git/" },
                -- Default values except for --hidden
                vimgrep_arguments = {
                    "rg", "--color=never", "--no-heading", "--with-filename",
                    "--line-number", "--column", "--smart-case", "--no-binary",
                    "--hidden" -- Search also hidden files
                },
            },
            pickers = {
                find_files = { theme = "dropdown", previewer = false, hidden = true },
                buffers = {
                    theme = "dropdown",
                    previewer = false,
                    -- Ignore the No Name buffer
                    -- Ignore the buffer opening nvim with "nvim ."
                    file_ignore_patterns = { "^%[No Name%]$", "^%.$" }
                }
            }
        },
        keys = {
            { "<C-p>",  "<cmd>lua require('telescope.builtin').find_files()<cr>",      desc = "Find files" },
            { "<leader>o", "<cmd>lua require('telescope.builtin').find_files()<cr>",   desc = "Find files" },
            { "<leader>fu", "<cmd>lua require('telescope.builtin').grep_string()<cr>", desc = "Find word under the cursor" },
            { "<leader>fs", "<cmd>lua require('telescope.builtin').live_grep()<cr>",   desc = "Find string" },
            { "<leader>b",  "<cmd>lua require('telescope.builtin').buffers()<cr>",     desc = "Find buffers" },
            { "<leader>fk", "<cmd>lua require('telescope.builtin').keymaps()<cr>",     desc = "Find keymap" },
        },
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
    }
}
