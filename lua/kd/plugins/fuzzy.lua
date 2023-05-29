return {
  {
    "ibhagwan/fzf-lua",
    dependencies = { "vijaymarupudi/nvim-fzf" },
    config = function()
      require("kd.plugins.configs.fzf-lua")
    end,
  },
}
