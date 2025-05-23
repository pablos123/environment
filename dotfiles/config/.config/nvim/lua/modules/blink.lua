return {
    {
        'saghen/blink.cmp',
        lazy = false, -- Lazy loading handled internally
        version = '*',
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
            cmdline = {
                enabled = false,
            },
        },
    },
    'rafamadriz/friendly-snippets',
}
