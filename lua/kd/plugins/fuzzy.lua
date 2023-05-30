return {
  {
    "junegunn/fzf",
    build = ":call fzf#install()",
  },
  require("kd/utils").os.is_windows and {
    "junegunn/fzf.vim",
    dependencies = { "junegunn/fzf" },
    config = function()
      require("kd.plugins.configs.fzf-vim")
    end,
  } or {
    "ibhagwan/fzf-lua",
    dependencies = { "junegunn/fzf", "vijaymarupudi/nvim-fzf" },
    config = function()
      require("kd.plugins.configs.fzf-lua")
    end,
  },
}
