return {
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'hrsh7th/cmp-nvim-lsp',

    'L3MON4D3/LuaSnip',
    'saadparwaiz1/cmp_luasnip',

    'rafamadriz/friendly-snippets',
    {
        'hrsh7th/nvim-cmp',
        config = function()
            require 'luasnip.loaders.from_vscode'.lazy_load()

            local cmp = require 'cmp'
            local luasnip = require("luasnip")

            local select_comp = cmp.mapping(function(fallback)
                if cmp.visible() then
                    if luasnip.expandable() then
                        luasnip.expand()
                    else
                        cmp.confirm({
                            select = true,
                        })
                    end
                else
                    fallback()
                end
            end)

            local next_comp = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                elseif luasnip.locally_jumpable(1) then
                    luasnip.jump(1)
                else
                    fallback()
                end
            end, { 'i', 's' })

            local previous_comp = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                elseif luasnip.locally_jumpable(-1) then
                    luasnip.jump(-1)
                else
                    fallback()
                end
            end, { 'i', 's' })

            local disable_cmp_in_comments = function()
                -- disable completion in comments
                local context = require 'cmp.config.context'
                -- keep command mode completion enabled when cursor is in a comment
                if vim.api.nvim_get_mode().mode == 'c' then
                    return true
                else
                    return not context.in_treesitter_capture("comment")
                        and not context.in_syntax_group("Comment")
                end
            end

            cmp.setup {
                snippet = {
                    expand = function(args)
                        require('luasnip').lsp_expand(args.body)
                    end,
                },
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' },
                }, {
                    { name = 'buffer' },
                    { name = 'path' },
                }),
                enabled = disable_cmp_in_comments,
                completion = {
                    completeopt = 'menu,menuone,noinsert'
                },
                mapping = {
                    ['<CR>'] = select_comp,
                    ['<Tab>'] = next_comp,
                    ['<S-Tab>'] = previous_comp,
                    ['<C-n>'] = next_comp,
                    ['<C-p>'] = previous_comp,
                },
            }
        end,
    },
}
