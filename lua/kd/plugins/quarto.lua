return {
  {
    "quarto-dev/quarto-nvim",
    config = function()
      -- disable conceal in markdown/quarto
      vim.g["pandoc#syntax#conceal#use"] = false

      -- embeds are already handled by treesitter injectons
      vim.g["pandoc#syntax#codeblocks#embeds#use"] = true
      vim.g["pandoc#syntax#conceal#blacklist"] = { "codeblock_delim", "codeblock_start" }

      -- but allow some types of conceal in math regions:
      -- see `:h g:tex_conceal`
      vim.g["tex_conceal"] = "gm"

      require("quarto").setup({
        debug = false,
        closePreviewOnExit = true,
        lspFeatures = {
          enabled = true,
          languages = { "python", "julia", "bash", "lua", "rust" },
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
      { "jmbuhr/otter.nvim" },
    },
  },
}
