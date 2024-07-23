return {
  {
    "junegunn/fzf",
    build = ":call fzf#install()",
  },
  {
    "ibhagwan/fzf-lua",
    dependencies = { "junegunn/fzf", "vijaymarupudi/nvim-fzf", "nvim-tree/nvim-web-devicons" },
    config = function()
      require("kd.plugins.configs.fzf-lua")
    end,
  },
}
