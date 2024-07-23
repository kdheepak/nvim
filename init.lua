---@param plugin string
local function bootstrap(plugin)
  local _, _, name = string.find(plugin, [[%S+/(%S+)]])
  local path = vim.fn.stdpath("data") .. "/lazy/" .. name

  if not vim.loop.fs_stat(path) then
    vim.print(string.format("Bootstraping '%s' to %s", name, path))
    vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/" .. plugin, path })
    vim.cmd([[redraw]])
  end
  vim.opt.runtimepath:prepend(path)
end

bootstrap("folke/lazy.nvim")
bootstrap("rktjmp/hotpot.nvim")

require("hotpot").setup({
  provide_require_fennel = true,
  enable_hotpot_diagnostics = false,
  compiler = {
    modules = {
      correlate = true,
      env = "_COMPILER",
      compilerEnv = _G,
      allowedGlobals = true,
    },
    macros = {
      env = "_COMPILER",
      compilerEnv = _G,
      allowedGlobals = true,
    },
  },
})

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
