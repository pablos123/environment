return {
    -- comments
    {
        "echasnovski/mini.comment",
        version = false,
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

    -- live colors
    {
        "echasnovski/mini.hipatterns",
        version = false,
        config = function(_, _)
            local hipatterns = require "mini.hipatterns"
            hipatterns.setup({
                highlighters = {
                    -- Highlight standalone "FIXME", "HACK", "TODO", "NOTE"
                    fixme     = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
                    hack      = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
                    todo      = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
                    note      = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },

                    -- Highlight hex color strings (`#rrggbb`) using that color
                    hex_color = hipatterns.gen_highlighter.hex_color(),
                },
            })
        end,
    },

    -- move text chunks
    {
        "echasnovski/mini.move",
        version = false,
        config = function(_, _)
            local options = {
                mappings = {
                    left = '<C-h>',
                    right = '<C-l>',
                    down = '<C-j>',
                    up = '<C-k>',
                    line_left = '<C-h>',
                    line_right = '<C-l>',
                    line_down = '<C-j>',
                    line_up = '<C-k>',
                },
            }
            require "mini.move".setup(options)
        end,
    },

    -- highlight current indent
    {
        "echasnovski/mini.indentscope",
        version = false,
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            symbol = "│",
            options = { try_as_border = true },
        },
        init = function()
            vim.api.nvim_create_autocmd("FileType", {
                pattern = { "help", "Trouble", "lazy", "mason" },
                callback = function()
                    vim.b.miniindentscope_disable = true
                end,
            })
        end,
        config = function(_, options)
            require "mini.indentscope".setup(options)
        end,
    },

    -- highlight trailspace
    {
        "echasnovski/mini.trailspace",
        version = false,
        config = function(_, options)
            require "mini.trailspace".setup(options)
            vim.api.nvim_create_autocmd("BufWritePre", {
                desc = "Clean trail space before saving",
                callback = function(event)
                    MiniTrailspace.trim()
                end
            })
        end,
    },

    -- highlight all ocurrencies of word under cursor
    {
        "echasnovski/mini.cursorword",
        version = false,
        config = function(_, options)
            require "mini.cursorword".setup(options)
        end,
    },

    -- file system
    {
        'echasnovski/mini.files',
        version = false,
        config = function(_, options)
            require "mini.files".setup(options)
        end,
    },
}
