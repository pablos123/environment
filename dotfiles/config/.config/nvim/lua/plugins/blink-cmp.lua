require 'blink.cmp'.setup(
    {
        keymap = {
            preset = 'default',
            ['<Up>'] = { 'select_prev', 'fallback' },
            ['<Down>'] = { 'select_next', 'fallback' },
            ['<S-Tab>'] = { 'select_prev', 'fallback' },
            ['<Tab>'] = { 'select_next', 'fallback' },
            ['<CR>'] = { 'accept', 'fallback' },
        },
        signature = {
            enabled = true
        },
        cmdline = {
            enabled = false,
        },
        completion = {
            menu = {
                draw = {
                    columns = {
                        { 'label', 'label_description', gap = 1 },
                    },
                },
            },
        },
        fuzzy = { implementation = "lua", }

    }
)
