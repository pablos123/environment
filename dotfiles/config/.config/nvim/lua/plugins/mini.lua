return {
    {
        "echasnovski/mini.nvim",
        version = false,
        config = function()
            require "mini.pairs".setup {}
            require "mini.surround".setup {}
            require "mini.operators".setup {}
            require "mini.ai".setup {}
            require "mini.cursorword".setup {}
            require "mini.indentscope".setup {}
            require "mini.trailspace".setup {}
            require "mini.statusline".setup {}
            require "mini.files".setup {}
            require "mini.notify".setup {}
            require "mini.hipatterns".setup {
                highlighters = {
                    fixme     = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
                    hack      = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
                    todo      = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
                    note      = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
                    hex_color = require "mini.hipatterns".gen_highlighter.hex_color(),
                },
            }
            require "mini.move".setup {
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
            require "mini.comment".setup {
                options = {
                    custom_commentstring = function()
                        return require "ts_context_commentstring".calculate_commentstring() or vim.bo.commentstring
                    end,
                },
            }
            vim.api.nvim_create_autocmd("BufWritePre", {
                desc = "Clean trail space before saving",
                callback = function()
                    MiniTrailspace.trim()
                end
            })
            vim.keymap.set("n", "gt", "<cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0), false)<cr>", opts)
        end,
    },
}
