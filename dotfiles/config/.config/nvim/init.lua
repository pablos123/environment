if vim.g.vscode then -- VSCode extension
    require "core/vscode"
    return
end

require "core/base"
require "core/mappings"
require "core/autocmd"

-- Faster startup
vim.loader.enable()
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git", "--branch=stable",
        lazypath
    })
end
vim.opt.rtp:prepend(lazypath)
require "lazy".setup "plugins"
