return {
  "echasnovski/mini.nvim",
  version = false,
  dependencies = { "nvim-tree/nvim-web-devicons", "nvim-treesitter/nvim-treesitter-textobjects" },
  config = function()
    require("mini.ai").setup()
    require("mini.indentscope").setup()
    require("mini.align").setup()
    require("mini.bracketed").setup()
    require("mini.bufremove").setup({
      keys = {
        {
          "<leader>bd",
          function()
            require("mini.bufremove").delete(0, false)
          end,
          desc = "Delete Buffer",
        },
        {
          "<leader>bD",
          function()
            require("mini.bufremove").delete(0, true)
          end,
          desc = "Delete Buffer (Force)",
        },
      },
    })
    require("mini.comment").setup({
      options = {
        custom_commentstring = function()
          return require("ts_context_commentstring.internal").calculate_commentstring() or vim.bo.commentstring
        end,
      },
    })
    require("mini.splitjoin").setup()
    require("mini.surround").setup()
  end,
}
