return {
  "nvim-lua/plenary.nvim",
  -- makes some plugins dot-repeatable like leap
  { "tpope/vim-repeat", event = "VeryLazy" },
  {
    "haya14busa/vim-asterisk",
    config = function()
      vim.g["asterisk#keeppos"] = 1
      local map = require("kd/utils").map
      map("", "*", "<Plug>(asterisk-z*)")
      map("", "#", "<Plug>(asterisk-z#)")
      map("", "g*", "<Plug>(asterisk-gz*)")
      map("", "g#", "<Plug>(asterisk-gz#)")
    end,
  },
  { "moll/vim-bbye", event = "VeryLazy" },
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end,
  },
  { "mbbill/undotree", event = "VeryLazy" },
  { "tpope/vim-unimpaired", event = "VeryLazy" }, -- complementary pairs of mappings
  { "tpope/vim-abolish", event = "VeryLazy" }, -- convert camel to snake
  { "tpope/vim-surround", event = "VeryLazy" }, -- all about surroundings: parentheses, brackets, quotes, XML tags, and more.
  { "tpope/vim-repeat", event = "VeryLazy" }, -- repeat.vim remaps . in a way that plugins can tap into it.
  { "tpope/vim-speeddating", event = "VeryLazy" }, -- Tools for working with dates
  { "tpope/vim-eunuch", event = "VeryLazy" }, -- vim sugar for UNIX shell commands like :Rename
  { "tpope/vim-sleuth", event = "VeryLazy" }, -- This plugin automatically adjusts 'shiftwidth' and 'expandtab' heuristically based on the current file
  { "tpope/vim-dadbod" }, -- Database interface
  { "kristijanhusak/vim-dadbod-ui" }, -- UI Database interface
  { "inkarkat/vim-visualrepeat", event = "VeryLazy" }, -- repetition of vim built-in normal mode commands via . for visual mode
  { "Konfekt/vim-CtrlXA", event = "VeryLazy" }, -- Increment and decrement and toggle keywords
  { "dhruvasagar/vim-zoom", event = "VeryLazy" },
  { "godlygeek/tabular", event = "VeryLazy" },
  { "dhruvasagar/vim-table-mode", event = "VeryLazy" },
  { "chrisbra/unicode.vim", event = "VeryLazy" },
  { "kevinhwang91/nvim-bqf", ft = "qf" },
  {
    "spywhere/detect-language.nvim",
    config = function()
      require("detect-language").setup({})
    end,
  },
  {
    "akinsho/toggleterm.nvim",
    config = function()
      local nnoremap = require("kd/utils").nnoremap
      nnoremap("<leader>/", "<cmd>ToggleTerm direction=horizontal<CR>", { desc = "Split terminal horizontally" })
      nnoremap("<leader>\\", "<cmd>ToggleTerm direction=vertical<CR>", { desc = "Split terminal vertically" })
      require("toggleterm").setup({
        -- size can be a number or function which is passed the current terminal
        open_mapping = [[<c-\><c-\>]],
        hide_numbers = true, -- hide the number column in toggleterm buffers
        shade_terminals = false,
        start_in_insert = false,
        insert_mappings = true, -- whether or not the open mapping applies in insert mode
        persist_size = true,
        direction = "float",
        close_on_exit = true, -- close the terminal window when the process exits
        -- This field is only relevant if direction is set to 'float'
        float_opts = { border = "curved" },
      })
    end,
    event = "VeryLazy",
  },
  { "GutenYe/json5.vim", ft = "json" },
  { "GCBallesteros/jupytext.vim", ft = { "ipynb", "python", "markdown" } },
  { "sindrets/diffview.nvim", event = "VeryLazy" },
  {
    "Pocco81/HighStr.nvim",
    config = function()
      local vnoremap = require("kd/utils").vnoremap
      local nnoremap = require("kd/utils").nnoremap
      vnoremap("<leader>h1", ":<c-u>HSHighlight 1<CR>", { desc = "Highlight 1" })
      vnoremap("<leader>h2", ":<c-u>HSHighlight 2<CR>", { desc = "Highlight 2" })
      vnoremap("<leader>h3", ":<c-u>HSHighlight 3<CR>", { desc = "Highlight 3" })
      vnoremap("<leader>h4", ":<c-u>HSHighlight 4<CR>", { desc = "Highlight 4" })
      vnoremap("<leader>h5", ":<c-u>HSHighlight 5<CR>", { desc = "Highlight 5" })
      vnoremap("<leader>h6", ":<c-u>HSHighlight 6<CR>", { desc = "Highlight 6" })
      vnoremap("<leader>h7", ":<c-u>HSHighlight 7<CR>", { desc = "Highlight 7" })
      vnoremap("<leader>h8", ":<c-u>HSHighlight 8<CR>", { desc = "Highlight 8" })
      vnoremap("<leader>h9", ":<c-u>HSHighlight 9<CR>", { desc = "Highlight 9" })
      vnoremap("<leader>h0", ":<c-u>HSRmHighlight<CR>", { desc = "Highlight Remove" })
      vnoremap("<leader>hh", ":<c-u>HSRmHighlight rm_all<CR>", { desc = "Highlight Remove all" })
      nnoremap("<leader>hh", ":<c-u>HSRmHighlight rm_all<CR>", { desc = "Highlight Remove all" })
    end,
    event = "VeryLazy",
  },
  { "jbyuki/nabla.nvim", ft = "markdown" }, -- Take your scentific notes in Neovim.
  { "jbyuki/venn.nvim", event = "VeryLazy" }, -- Draw ASCII diagrams in Neovim.
}
