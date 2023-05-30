return {
  {
    "quarto-dev/quarto-nvim",
    dev = false,
    ft = "quarto",
    config = function()
      -- disable conceal in markdown/quarto
      vim.g["pandoc#syntax#conceal#use"] = false

      -- embeds are already handled by treesitter injectons
      vim.g["pandoc#syntax#codeblocks#embeds#use"] = false
      vim.g["pandoc#syntax#conceal#blacklist"] = { "codeblock_delim", "codeblock_start" }

      -- but allow some types of conceal in math regions:
      -- see `:h g:tex_conceal`
      vim.g["tex_conceal"] = "gm"

      require("quarto").setup({
        debug = false,
        closePreviewOnExit = true,
        lspFeatures = {
          enabled = true,
          languages = { "python", "julia", "bash", "lua" },
          chunks = "curly", -- 'curly' or 'all'
          diagnostics = {
            enabled = true,
            triggers = { "BufWritePost" },
          },
          completion = {
            enabled = true,
          },
        },
        keymap = {
          hover = "K",
          definition = "gd",
        },
      })
    end,
    dependencies = {
      { "vim-pandoc/vim-pandoc-syntax" },
      { "hrsh7th/nvim-cmp" },
      {
        "jmbuhr/otter.nvim",
        dev = false,
        config = function()
          require("otter.config").setup({
            lsp = {
              hover = {
                border = require("misc.style").border,
              },
            },
          })
        end,
      },
      {
        "quarto-dev/quarto-vim",
      },
    },
  },
}
