return {
    {
        'MagicDuck/grug-far.nvim',
        config = function()
            local grug_far = require('grug-far')

            grug_far.setup({
                helpLine = {
                    enabled = false,
                },
                engines = {
                    ripgrep = {
                        extraArgs = "--hidden --multiline",
                    },
                },
                windowCreationCommand = '',
                normalModeSearch = false,
                transient = true,
                wrap = false,
                showCompactInputs = true,
                showInputsTopPadding = false,
                showInputsBottomPadding = false,
                staticTitle = 'Wise Wizard',
            })

            vim.keymap.set('n', '<leader>s', function()
                vim.cmd.vnew()
                vim.cmd.wincmd 'L'
                vim.api.nvim_win_set_width(0, 40)
                vim.wo.winfixwidth = true
                grug_far.open()
            end)
        end,
    },
}
