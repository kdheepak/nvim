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
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "paopaol/telescope-git-diffs.nvim",
        config = function()
          require("telescope").load_extension("git_diffs")
        end,
        dependencies = {
          "nvim-lua/plenary.nvim",
          "sindrets/diffview.nvim",
        },
      },
      {
        "xiyaowong/telescope-emoji.nvim",
        config = function()
          require("telescope").load_extension("emoji")
        end,
      },
      {
        "tsakirist/telescope-lazy.nvim",
        config = function()
          require("telescope").load_extension("lazy")
        end,
      },
    },
    config = function()
      local actions = require("telescope.actions")
      local action_state = require("telescope.actions.state")
      local telescopeConfig = require("telescope.config")

      local transform_mod = require("telescope.actions.mt").transform_mod

      local function multiopen(prompt_bufnr, method)
        local edit_file_cmd_map = {
          vertical = "vsplit",
          horizontal = "split",
          tab = "tabedit",
          default = "edit",
        }
        local edit_buf_cmd_map = {
          vertical = "vert sbuffer",
          horizontal = "sbuffer",
          tab = "tab sbuffer",
          default = "buffer",
        }
        local picker = action_state.get_current_picker(prompt_bufnr)
        local multi_selection = picker:get_multi_selection()

        if #multi_selection > 1 then
          require("telescope.pickers").on_close_prompt(prompt_bufnr)
          pcall(vim.api.nvim_set_current_win, picker.original_win_id)

          for i, entry in ipairs(multi_selection) do
            local filename, row, col

            if entry.path or entry.filename then
              filename = entry.path or entry.filename

              row = entry.row or entry.lnum
              col = vim.F.if_nil(entry.col, 1)
            elseif not entry.bufnr then
              local value = entry.value
              if not value then
                return
              end

              if type(value) == "table" then
                value = entry.display
              end

              local sections = vim.split(value, ":")

              filename = sections[1]
              row = tonumber(sections[2])
              col = tonumber(sections[3])
            end

            local entry_bufnr = entry.bufnr

            if entry_bufnr then
              if not vim.api.nvim_buf_get_option(entry_bufnr, "buflisted") then
                vim.api.nvim_buf_set_option(entry_bufnr, "buflisted", true)
              end
              local command = i == 1 and "buffer" or edit_buf_cmd_map[method]
              pcall(vim.cmd, string.format("%s %s", command, vim.api.nvim_buf_get_name(entry_bufnr)))
            else
              local command = i == 1 and "edit" or edit_file_cmd_map[method]
              if vim.api.nvim_buf_get_name(0) ~= filename or command ~= "edit" then
                filename = require("plenary.path"):new(vim.fn.fnameescape(filename)):normalize(vim.loop.cwd())
                pcall(vim.cmd, string.format("%s %s", command, filename))
              end
            end

            if row and col then
              pcall(vim.api.nvim_win_set_cursor, 0, { row, col })
            end
          end
        else
          actions["select_" .. method](prompt_bufnr)
        end
      end

      local custom_actions = transform_mod({
        multi_selection_open_vertical = function(prompt_bufnr)
          multiopen(prompt_bufnr, "vertical")
        end,
        multi_selection_open_horizontal = function(prompt_bufnr)
          multiopen(prompt_bufnr, "horizontal")
        end,
        multi_selection_open_tab = function(prompt_bufnr)
          multiopen(prompt_bufnr, "tab")
        end,
        multi_selection_open = function(prompt_bufnr)
          multiopen(prompt_bufnr, "default")
        end,
      })

      local function stopinsert(callback)
        return function(prompt_bufnr)
          vim.cmd.stopinsert()
          vim.schedule(function()
            callback(prompt_bufnr)
          end)
        end
      end

      local multi_open_mappings = {
        i = {},
        n = {
          ["<C-v>"] = custom_actions.multi_selection_open_vertical,
          ["<C-s>"] = custom_actions.multi_selection_open_horizontal,
          ["<C-t>"] = custom_actions.multi_selection_open_tab,
          ["<CR>"] = custom_actions.multi_selection_open,
        },
      }

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

              ["<C-l>"] = actions.complete_tag,
              ["<C-h>"] = actions.which_key, -- keys from pressing <C-h>

              ["<C-n>"] = actions.cycle_history_next,
              ["<C-p>"] = actions.cycle_history_prev,

              ["<C-b>"] = actions.results_scrolling_up,
              ["<C-f>"] = actions.results_scrolling_down,

              ["<C-c>"] = actions.close,

              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,

              -- ["<CR>"] = actions.select_default,
              -- ["<C-s>"] = actions.select_horizontal,
              -- ["<C-v>"] = actions.select_vertical,
              --
              -- ["<C-t>"] = actions.select_tab,
              ["<tab>"] = actions.toggle_selection + actions.move_selection_next,
              ["<s-tab>"] = actions.toggle_selection + actions.move_selection_previous,
              ["<C-space>"] = actions.toggle_selection,
              ["<C-v>"] = stopinsert(custom_actions.multi_selection_open_vertical),
              ["<C-s>"] = stopinsert(custom_actions.multi_selection_open_horizontal),
              ["<C-t>"] = stopinsert(custom_actions.multi_selection_open_tab),
              ["<CR>"] = stopinsert(custom_actions.multi_selection_open),
            },
            n = {
              ["<C-v>"] = custom_actions.multi_selection_open_vertical,
              ["<C-s>"] = custom_actions.multi_selection_open_horizontal,
              ["<C-t>"] = custom_actions.multi_selection_open_tab,
              ["<C-space>"] = actions.toggle_selection,
              ["<tab>"] = actions.toggle_selection + actions.move_selection_next,
              ["<s-tab>"] = actions.toggle_selection + actions.move_selection_previous,
              ["<CR>"] = custom_actions.multi_selection_open,
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
    build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
    config = function()
      require("telescope").load_extension("fzf")
    end,
  },
}
