local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

local hotpotpath = vim.fn.stdpath("data") .. "/lazy/hotpot.nvim"
if not vim.loop.fs_stat(hotpotpath) then
  vim.notify("Bootstrapping hotpot.nvim...", vim.log.levels.INFO)
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--single-branch",
    "--branch=v0.12.0",
    "https://github.com/rktjmp/hotpot.nvim.git",
    hotpotpath,
  })
end

-- As per lazy's install instructions, but insert hotpots path at the front
vim.opt.runtimepath:prepend({ hotpotpath, lazypath })

vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("lazy").setup({
  spec = { { import = "kd/plugins" } },
  install = {
    -- try to load one of these colorschemes when starting an installation during startup
    colorscheme = { "rose-pine" },
  },
  change_detection = {
    -- automatically check for config file changes and reload the ui
    enabled = false,
    notify = false, -- get a notification when changes are found
  },
})

require("kd.mappings")
require("kd.highlights")
require("kd.options")
require("kd.autocmds")
