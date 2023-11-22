local lsp = require "lsp-zero".preset({})

lsp.on_attach(function(_, bufnr)
    lsp.default_keymaps({ buffer = bufnr })
end)

-- https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers
lsp.ensure_installed({
    "tsserver",
    "html",
    "ruff_lsp",
    "perlnavigator",
})

require "lspconfig".lua_ls.setup(lsp.nvim_lua_ls())

lsp.setup()

require "mason-null-ls".setup({
    -- anything supported by mason.
    ensure_installed = {
        "shellcheck",
        "djlint",
        "black",
    },
    -- will automatically install masons tools based on selected sources in `null-ls`.
    -- Can also be an exclusion list. This has no sense here, so set it to false.
    automatic_installation = false,
    handlers = {},
})
require "null-ls".setup({
    -- anything not supported by mason.
    sources = { }
})

-- completion
local cmp = require "cmp"
local cmp_action = require "lsp-zero".cmp_action()

require "luasnip.loaders.from_vscode".lazy_load()

cmp.setup({
    -- add borders to the completion menu
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    sources = {
        { name = "path" },
        {
            name = "nvim_lsp",
            entry_filter = function(entry, _)
                return require "cmp.types".lsp.CompletionItemKind[entry:get_kind()] ~= "Text"
            end
        },
        { name = 'luasnip', keyword_length = 2 },
        { name = 'buffer',  keyword_length = 3 },
    },
    mapping = {
        -- supertab completion
        ["<tab>"] = cmp_action.luasnip_supertab(),
        ["<s-tab>"] = cmp_action.luasnip_shift_supertab(),
        -- `enter` key to confirm completion
        ["<cr>"] = cmp.mapping.confirm({ select = false }),
        -- ctrl+space to trigger completion menu
        ["<c-space>"] = cmp.mapping.complete(),
    },
})

cmp.setup.cmdline("/", { sources = { { name = "path" } } })
