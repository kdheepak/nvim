return {
  {
    "ibhagwan/fzf-lua",
    dependencies = { "vijaymarupudi/nvim-fzf" },
    config = function()
      require("kd.plugins.configs.fzf-lua")
    end,
  },
  { "junegunn/fzf.vim" },
  { "junegunn/fzf", dir = "~/.fzf", build = "./install --all" },
}
