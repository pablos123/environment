local map = vim.api.nvim_set_keymap
local function add_desc(desc)
    if desc == nil then
        desc = ""
    end
    return { noremap = true, silent = true, desc = desc }
end

map("v", "<", "<gv", add_desc("To keep selected when pressing tab on selected lines"))
map("v", ">", ">gv", add_desc("To keep selected when pressing tab on selected lines"))

map("n", "Y", "y$", add_desc("Yank to the end of line"))

map("n", "n", "nzzzv", add_desc("Centered search"))
map("n", "N", "Nzzzv", add_desc("Centered search"))

map("n", "J", "mzJ`z", add_desc("Maintain cursor position when deleting line break"))

map("i", ",", ",<c-g>u", add_desc("Add break point in insert mode"))
map("i", ".", ".<c-g>u", add_desc("Add break point in insert mode"))
map("i", "!", "!<c-g>u", add_desc("Add break point in insert mode"))
map("i", "?", "?<c-g>u", add_desc("Add break point in insert mode"))
map("i", ":", ":<c-g>u", add_desc("Add break point in insert mode"))

map("v", "//", "y/\\V<c-r>=escape(@\",'/\\')<cr><cr>", add_desc("Search for visually highlighted"))
