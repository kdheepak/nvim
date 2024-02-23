local utils = require("kd.utils")
local augroup = utils.augroup
local autocmd = utils.autocmd

augroup("KDAutocmds", function()
  autocmd("InsertLeave", "set nopaste")

  -- Enable spell checking for certain file types
  autocmd({ "BufRead", "BufNewFile" }, function()
    vim.opt.spell = true
    vim.opt.spelllang = "en,fr"
  end, { pattern = { "*.txt", "*.md", "*.qmd", "*.tex" } })

  autocmd("FileType", "setlocal spell", { pattern = "gitcommit" })

  -- don't auto comment new line
  autocmd("BufEnter", [[set formatoptions-=cro]])

  autocmd({ "BufRead", "BufNewFile" }, function()
    vim.api.nvim_command("set filetype=typst")
  end, { pattern = { "*.typ" } })

  autocmd("FileType", "setl bufhidden=delete", { pattern = { "gitcommit", "gitrebase", "gitconfig" } })

  -- Ensure comments don't go to beginning of line by default
  autocmd("FileType", "setlocal nosmartindent")

  -- resize panes when host window is resized
  autocmd("VimResized", "wincmd =")

  autocmd({ "BufWinEnter", "BufRead", "BufNewFile" }, "setlocal formatoptions-=c formatoptions-=r formatoptions-=o")

  autocmd({ "BufWinEnter", "BufRead", "BufNewFile" }, "setlocal wrap")

  autocmd("TextYankPost", function()
    require("vim.highlight").on_yank({ higroup = "Search", timeout = 500 })
  end)

  autocmd({ "BufWinEnter", "BufRead", "BufNewFile" }, function()
    if vim.fn.getline(1) == "#!/usr/bin/env julia" then
      vim.cmd("setfiletype julia")
    end
    if vim.fn.getline(1) == "#!/usr/bin/env python3" then
      vim.cmd("setfiletype python")
    end
  end)

  -- go to last loc when opening a buffer
  autocmd("BufReadPost", function()
    local mark = vim.api.nvim_buf_get_mark(0, "\"")
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end)

  -- windows to close with "q"
  autocmd("FileType", function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end, {
    pattern = {
      "dap-float",
      "fugitive",
      "help",
      "man",
      "notify",
      "qf",
      "PlenaryTestPopup",
      "startuptime",
      "tsplayground",
    },
  })

  autocmd("FileType", [[nnoremap <buffer><silent> q :quit<CR>]], { pattern = "man" })

  -- show cursorline only in active window
  autocmd({ "InsertLeave", "WinEnter" }, "set cursorline")
  autocmd({ "InsertEnter", "WinLeave" }, "set nocursorline")

  vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*",
    callback = function()
      vim.wo.conceallevel = 0
    end,
  })

  vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = function()
      vim.wo.conceallevel = 0
    end,
  })

  autocmd("CursorHold", function()
    vim.diagnostic.open_float(nil, {
      focusable = false,
      scope = "cursor",
      border = "rounded",
      close_events = {
        "BufLeave",
        "InsertEnter",
        "FocusLost",
        "CursorMoved",
        "CursorMovedI",
        "BufHidden",
        "InsertCharPre",
        "WinLeave",
      },
    })
  end, {
    desc = "Show diagnostics under the cursor when holding position",
    pattern = "*",
  })

  autocmd("BufWipeout", function()
    vim.schedule(function()
      require("bufferline.state").set_offset(0)
    end)
  end, {
    desc = "Auto close NvimTree when a file is opened",
    pattern = "NvimTree_*",
  })

  autocmd("TermOpen", "setlocal listchars= nonumber norelativenumber nocursorline")

  autocmd({ "TermOpen", "BufEnter", "BufWinEnter", "WinEnter" }, function()
    if vim.opt.buftype:get() == "terminal" then
      vim.opt_local.wrap = true
      vim.opt_local.spell = false
      vim.opt_local.signcolumn = "no"
      vim.cmd(":startinsert")
    end
  end)

  autocmd("TermClose", function()
    if package.loaded["neo-tree.sources.git_status"] then
      require("neo-tree.sources.git_status").refresh()
    end
  end, {
    pattern = "*lazygit",
    desc = "Refresh Neo-Tree git when closing lazygit",
  })
end)

-- Autocommands to change "commentstring" for specific filetypes. TODO: Create lua version.
-- Use "//" instead of "/* */" for 'C' and 'cpp' files.
vim.cmd([[
augroup set-commentstring-ag
autocmd!
    autocmd BufEnter *.c :lua vim.api.nvim_buf_set_option(0, "commentstring", "// %s")
    autocmd BufFilePost *.c :lua vim.api.nvim_buf_set_option(0, "commentstring", "// %s")

    autocmd BufEnter *.cpp :lua vim.api.nvim_buf_set_option(0, "commentstring", "// %s")
    autocmd BufFilePost *.cpp :lua vim.api.nvim_buf_set_option(0, "commentstring", "// %s")

    autocmd BufEnter *.h :lua vim.api.nvim_buf_set_option(0, "commentstring", "// %s")
    autocmd BufFilePost *.h :lua vim.api.nvim_buf_set_option(0, "commentstring", "// %s")

    autocmd BufEnter *.hpp :lua vim.api.nvim_buf_set_option(0, "commentstring", "// %s")
    autocmd BufFilePost *.hpp :lua vim.api.nvim_buf_set_option(0, "commentstring", "// %s")

    autocmd BufEnter *.svelte :lua vim.api.nvim_buf_set_option(0, "commentstring", "<!-- %s -->")
    autocmd BufFilePost *.svelte :lua vim.api.nvim_buf_set_option(0, "commentstring", "<!-- %s -->")

    autocmd BufEnter *.fish :lua vim.api.nvim_buf_set_option(0, "commentstring", "# %s")
    autocmd BufFilePost *.fish :lua vim.api.nvim_buf_set_option(0, "commentstring", "# %s")
augroup END
]])
