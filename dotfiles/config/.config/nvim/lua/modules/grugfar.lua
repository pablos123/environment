return {
    {
        'MagicDuck/grug-far.nvim',
        config = function()
            require('grug-far').setup {
                helpLine = {
                    enabled = false,
                },
                transient = true,
                extraArgs = "--hidden -g '!{.git,.svn,.hg}'",
                keymaps = {
                    replace = { n = '<localleader>r' },
                    qflist = { n = '<localleader>q' },
                    refresh = { n = '<localleader>f' },
                    gotoLocation = { n = '<enter>' },
                    help = { n = 'g?' },
                    pickHistoryEntry = false,
                    syncLocations = false,
                    syncLine = false,
                    close = false,
                    historyOpen = false,
                    historyAdd = false,
                    openLocation = false,
                    openNextLocation = false,
                    openPrevLocation = false,
                    abort = false,
                    toggleShowCommand = false,
                    swapEngine = false,
                    previewLocation = false,
                    swapReplacementInterpreter = false,
                    applyNext = false,
                    applyPrev = false,
                },
            }
        end,
        keys = {
            { '<leader>s', '<cmd>GrugFar<cr>', desc = 'Open GrugFar' },
        },
    },
}
