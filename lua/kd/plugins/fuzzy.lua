return {
  -- {
  --   "junegunn/fzf",
  --   build = ":call fzf#install()",
  -- },
  -- require("kd.utils").os.is_windows and {
  --   "junegunn/fzf.vim",
  --   dependencies = { "junegunn/fzf" },
  --   config = function()
  --     require("kd.plugins.configs.fzf-vim")
  --   end,
  -- } or {
  --   "ibhagwan/fzf-lua",
  --   dependencies = { "junegunn/fzf", "vijaymarupudi/nvim-fzf" },
  --   config = function()
  --     require("kd.plugins.configs.fzf-lua")
  --   end,
  -- },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    -- NOTE: If you are having trouble with this installation,
    --       refer to the README for telescope-fzf-native for more instructions.
    build = "make",
    cond = function()
      return vim.fn.executable("make") == 1
    end,
  },
}
