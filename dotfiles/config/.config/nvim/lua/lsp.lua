vim.api.nvim_create_autocmd("LspAttach", {
    desc = "LSP actions",
    callback = function(event)
        local opts = { buffer = event.buf }

        -- buffer-local keybindings, they only work if you have an active language server
        vim.keymap.set("n", "gh", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
        vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
        vim.keymap.set("n", "<F12>", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
        vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
        vim.keymap.set("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
        vim.keymap.set("n", "<F4>", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
        vim.keymap.set({ "n", "x" }, "<F3>", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", opts)
    end
})

-- https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers
local language_servers = {
    "tsserver",
    "html",
    "ruff_lsp",
    "perlnavigator",
    "lua_ls",
    "ansiblels",
}
require "mason".setup({})
require "mason-lspconfig".setup({
    ensure_installed = language_servers,
    handlers = {
        function(server)
            require("lspconfig")[server].setup {}
        end
    },
})

local null_ls = require("null-ls")
null_ls.setup({
    sources = {
        null_ls.builtins.formatting.prettier,
        null_ls.builtins.formatting.djlint,
        null_ls.builtins.diagnostics.djlint,
    },
})
