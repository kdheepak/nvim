return {
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
  end,
}
