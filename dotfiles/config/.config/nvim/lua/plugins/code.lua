return {

    -- context comments
    { "JoosepAlviste/nvim-ts-context-commentstring", lazy = true },

    -- comments
    {
        "echasnovski/mini.comment",
        event = "VeryLazy",
        opts = {
            hooks = {
                pre = function()
                    require "ts_context_commentstring.internal".update_commentstring({})
                end,
            },
        },
        config = function(_, options)
            require "mini.comment".setup(options)
        end,
    },

    -- pairs
    {
        "echasnovski/mini.pairs",
        version = false,
        config = function(_, options)
            require "mini.pairs".setup(options)
        end,
    },

    -- surrond
    {
        "echasnovski/mini.surround",
        version = false,
        config = function(_, options)
            require "mini.surround".setup(options)
        end,
    },

    -- treesitter context
    {
        "nvim-treesitter/nvim-treesitter-context",
        version = false,
        config = function(_, options)
            require "mini.surround".setup(options)
        end,
    },
}
