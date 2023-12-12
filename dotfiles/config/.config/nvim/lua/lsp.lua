-- https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers
local language_servers = {
    "tsserver",
    "html",
    "ruff_lsp",
    "perlnavigator",
}

local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
  -- see :help lsp-zero-keybindings
  -- to learn the available actions
  lsp_zero.default_keymaps({buffer = bufnr})
end)

require('mason').setup({})
require('mason-lspconfig').setup({
  ensure_installed = language_servers,
  handlers = {
    lsp_zero.default_setup,
  },
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
