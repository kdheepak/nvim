return {
  "nvim-lua/plenary.nvim",
  -- makes some plugins dot-repeatable like leap
  { "tpope/vim-repeat", event = "VeryLazy" },
  {
    "haya14busa/vim-asterisk",
    config = function()
      vim.g["asterisk#keeppos"] = 1
      local map = require("kd.utils").map
      map("", "*", "<Plug>(asterisk-z*)")
      map("", "#", "<Plug>(asterisk-z#)")
      map("", "g*", "<Plug>(asterisk-gz*)")
      map("", "g#", "<Plug>(asterisk-gz#)")
    end,
  },
  { "moll/vim-bbye", event = "VeryLazy" },
  {
    "echasnovski/mini.nvim",
    version = false,
    dependencies = { "nvim-tree/nvim-web-devicons", "nvim-treesitter/nvim-treesitter-textobjects" },
    config = function()
      require("mini.ai").setup()
      require("mini.operators").setup()
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
  },
  { "mbbill/undotree", event = "VeryLazy" },
  { "tpope/vim-abolish", event = "VeryLazy" }, -- convert camel to snake
  { "tpope/vim-repeat", event = "VeryLazy" }, -- repeat.vim remaps . in a way that plugins can tap into it.
  { "tpope/vim-speeddating", event = "VeryLazy" }, -- Tools for working with dates
  { "tpope/vim-eunuch", event = "VeryLazy" }, -- vim sugar for UNIX shell commands like :Rename
  { "tpope/vim-sleuth", event = "VeryLazy" }, -- This plugin automatically adjusts 'shiftwidth' and 'expandtab' heuristically based on the current file
  { "tpope/vim-dadbod" }, -- Database interface
  {
    "rbong/vim-flog",
    lazy = true,
    cmd = { "Flog", "Flogsplit", "Floggit" },
    dependencies = {
      "tpope/vim-fugitive",
    },
  },
  { "kristijanhusak/vim-dadbod-ui" }, -- UI Database interface
  { "inkarkat/vim-visualrepeat", event = "VeryLazy" }, -- repetition of vim built-in normal mode commands via . for visual mode
  { "Konfekt/vim-CtrlXA", event = "VeryLazy" }, -- Increment and decrement and toggle keywords
  { "dhruvasagar/vim-zoom", event = "VeryLazy" },
  { "godlygeek/tabular", event = "VeryLazy" },
  -- { "chrisbra/unicode.vim", event = "VeryLazy" },
  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
  },
  {
    "spywhere/detect-language.nvim",
    config = function()
      require("detect-language").setup({})
    end,
  },
  {
    "akinsho/toggleterm.nvim",
    config = function()
      local nnoremap = require("kd.utils").nnoremap
      local tnoremap = require("kd.utils").tnoremap
      local toggleterm = require("toggleterm")
      local terminal = require("toggleterm.terminal")

      local function open_new_terminal(direction)
        if #terminal.get_all() ~= 0 then
          if direction == "horizontal" then
            direction = "vertical"
          else
            direction = "horizontal"
          end
        end
        local term = terminal.Terminal:new({ id = #terminal.get_all() + 1, direction = direction, size = 0.5 })
        term:toggle()
      end

      local function toggle_or_open_new_terminal(direction)
        open_new_terminal(direction)
      end

      local zellij_new_vertical = function()
        local cmd = "zellij action new-pane -d right"
        vim.fn.system(cmd)
      end

      local zellij_new_horizontal = function()
        local cmd = "zellij action new-pane -d down"
        vim.fn.system(cmd)
      end

      local zellij_new_floating = function()
        local cmd = "zellij action new-pane -f"
        vim.fn.system(cmd)
      end

      nnoremap("<leader>/", zellij_new_horizontal, { desc = "Split terminal horizontally" })
      nnoremap("<leader>\\", zellij_new_vertical, { desc = "Split terminal vertically" })

      -- nnoremap("<leader>/", function()
      --   toggle_or_open_new_terminal("horizontal")
      -- end, { desc = "Split terminal horizontally" })
      -- nnoremap("<leader>\\", function()
      --   toggle_or_open_new_terminal("vertical")
      -- end, { desc = "Split terminal vertically" })

      nnoremap("<Leader>tt", zellij_new_floating, { desc = "Toggle terminal" })

      tnoremap("<ESC><ESC>", "<C-\\><C-n>", { desc = "ESC to normal mode" })
      tnoremap("<S-Space>", "<Space>")

      require("toggleterm").setup({
        -- size can be a number or function which is passed the current terminal
        size = function(term)
          if term.direction == "horizontal" then
            return vim.o.lines * 0.5
          elseif term.direction == "vertical" then
            return vim.o.columns * 0.5
          end
        end,
        -- size can be a number or function which is passed the current terminal
        hide_numbers = true, -- hide the number column in toggleterm buffers
        shade_terminals = false,
        start_in_insert = true,
        insert_mappings = false,
        persist_size = false,
        direction = "float",
        close_on_exit = true,
        -- This field is only relevant if direction is set to 'float'
        float_opts = { border = "curved" },
      })
      local Terminal = require("toggleterm.terminal").Terminal

      local lazygit = Terminal:new({
        cmd = "lazygit",
        hidden = true,
        direction = "float",
        on_open = function(term)
          vim.cmd("startinsert!")
          vim.api.nvim_buf_set_keymap(0, "t", "<esc>", "<cmd>close<CR>", { silent = false, noremap = true })
          if vim.fn.mapcheck("<esc>", "t") ~= "" then
            vim.api.nvim_buf_del_keymap(term.bufnr, "t", "<esc>")
          end
        end,
      })
      local function lazygit_toggle()
        lazygit:toggle()
      end

      local lazygit_log = Terminal:new({
        cmd = "lazygit log",
        hidden = true,
        direction = "float",
        on_open = function(term)
          vim.cmd("startinsert!")
          vim.api.nvim_buf_set_keymap(0, "t", "<esc>", "<cmd>close<CR>", { silent = false, noremap = true })
          if vim.fn.mapcheck("<esc>", "t") ~= "" then
            vim.api.nvim_buf_del_keymap(term.bufnr, "t", "<esc>")
          end
        end,
      })
      local function lazygit_log_toggle()
        lazygit_log:toggle()
      end
      nnoremap("<leader>gg", lazygit_toggle, { desc = "LazyGit Toggle" })
      nnoremap("<leader>gl", lazygit_log_toggle, { desc = "LazyGit Log" })
    end,
  },
  { "GutenYe/json5.vim", ft = "json" },
  { "GCBallesteros/jupytext.vim", ft = { "ipynb", "python", "markdown" } },
  {
    "sindrets/diffview.nvim",
    config = function()
      require("diffview").setup({
        view = {
          -- Use 4-way diff (ours, base, theirs; local) for fixing conflicts
          merge_tool = {
            layout = "diff4_mixed",
            disable_diagnostics = true,
          },
        },
      })
    end,
  },
  {
    "Pocco81/HighStr.nvim",
    config = function()
      local vnoremap = require("kd.utils").vnoremap
      local nnoremap = require("kd.utils").nnoremap
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

  -- {
  --   "bennypowers/nvim-regexplainer",
  --   config = function()
  --     require("regexplainer").setup()
  --   end,
  --   requires = {
  --     "nvim-treesitter/nvim-treesitter",
  --     "MunifTanjim/nui.nvim",
  --   },
  -- },
  {
    "xemptuous/sqlua.nvim",
    lazy = true,
    cmd = "SQLua",
    config = function()
      require("sqlua").setup()
    end,
  },
}
