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
    config = function()
      local actions = require("telescope.actions")
      local telescopeConfig = require("telescope.config")

      -- Clone the default Telescope configuration
      local vimgrep_arguments = { unpack(telescopeConfig.values.vimgrep_arguments) }

      -- I want to search in hidden/dot files.
      table.insert(vimgrep_arguments, "--hidden")
      -- I don't want to search in the `.git` directory.
      table.insert(vimgrep_arguments, "--glob")
      table.insert(vimgrep_arguments, "!**/.git/*")

      require("telescope").setup({
        defaults = {
          selection_caret = " ",
          vimgrep_arguments = vimgrep_arguments,
          initial_mode = "insert",
          selection_strategy = "reset",
          sorting_strategy = "ascending",
          layout_strategy = "horizontal",
          layout_config = {
            prompt_position = "top",
            vertical = { mirror = false },
          },
          mappings = {
            i = {
              ["<esc>"] = actions.close,
              ["<c-d>"] = actions.delete_buffer + actions.move_to_top,

              ["<CR>"] = actions.select_default,
              ["<C-s>"] = actions.select_horizontal,
              ["<C-v>"] = actions.select_vertical,

              ["<C-t>"] = actions.select_tab,

              ["<C-l>"] = actions.complete_tag,
              ["<C-h>"] = actions.which_key, -- keys from pressing <C-h>

              ["<C-n>"] = actions.cycle_history_next,
              ["<C-p>"] = actions.cycle_history_prev,

              ["<C-b>"] = actions.results_scrolling_up,
              ["<C-f>"] = actions.results_scrolling_down,

              ["<C-c>"] = actions.close,

              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
            },
          },
        },
        pickers = {
          find_files = {
            -- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
            find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
          },
        },
      })
    end,
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
