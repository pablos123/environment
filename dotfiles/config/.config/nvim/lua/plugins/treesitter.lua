local languages = {
    "bash",
    "c",
    "html",
    "htmldjango",
    "javascript",
    "json",
    "lua",
    "luadoc",
    "luap",
    "markdown",
    "markdown_inline",
    "perl",
    "python",
    "query",
    "regex",
    "tsx",
    "typescript",
    "vim",
    "yaml",
}

return {
    {
        "nvim-treesitter/nvim-treesitter",
        version = false,
        build = ":TSUpdate",
        cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
        event = { "BufReadPost", "BufNewFile" },
        config = function(_, options)
            require "nvim-treesitter.configs".setup {
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
                indent = { enable = true },
                context_commentstring = { enable = true, enable_autocmd = false },
                ensure_installed = languages,
            }
        end,
    },
    "nvim-treesitter/playground",
}
