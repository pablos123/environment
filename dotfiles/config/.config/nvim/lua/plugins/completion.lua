return {
    {
        'saghen/blink.cmp',
        lazy = false, -- lazy loading handled internally
        version = 'v0.*',
        opts = {
            keymap = {
                preset = 'default',
                ['<Up>'] = { 'select_prev', 'fallback' },
                ['<Down>'] = { 'select_next', 'fallback' },
                ['<S-Tab>'] = { 'select_prev', 'fallback' },
                ['<Tab>'] = { 'select_next', 'fallback' },
                ['<CR>'] = { 'accept', 'fallback' },
            },
            signature = { enabled = true },
        },
    },
    'rafamadriz/friendly-snippets',
}
