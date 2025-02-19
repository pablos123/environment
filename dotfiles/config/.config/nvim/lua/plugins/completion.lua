return {
    {
        'saghen/blink.cmp',
        lazy = false, -- lazy loading handled internally
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
            sources = {
                providers = {
                    cmdline = {
                        -- Do not complete when pressing :q :w
                        enabled = function()
                            return not vim.fn.getcmdline():match("^[wq].*")
                        end
                    },
                },
            },
        },
    },
    'rafamadriz/friendly-snippets',
}
