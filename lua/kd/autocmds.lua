local utils = require("kd/utils")
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
  end, { pattern = { "*.typ" } } )

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

  autocmd("BufNewFile,BufRead", function()
    if vim.fn.getline(1) == "#!/usr/bin/env julia" then
      vim.cmd("setfiletype julia")
    end
    if vim.fn.getline(1) == "#!/usr/bin/env python3" then
      vim.cmd("setfiletype python")
    end
  end)

  -- go to last loc when opening a buffer
  autocmd("BufReadPost", function()
      local mark = vim.api.nvim_buf_get_mark(0, '"')
      local lcount = vim.api.nvim_buf_line_count(0)
      if mark[1] > 0 and mark[1] <= lcount then
        pcall(vim.api.nvim_win_set_cursor, 0, mark)
      end
    end
  )

  -- windows to close with "q"
  autocmd("FileType",
    function(event)
      vim.bo[event.buf].buflisted = false
      vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
    end,
    {
      pattern = {
        "dap-float",
        "fugitive",
        "help",
        "man",
        "notify",
        "null-ls-info",
        "qf",
        "PlenaryTestPopup",
        "startuptime",
        "tsplayground",
      },
    }
  )

  autocmd("FileType", [[nnoremap <buffer><silent> q :quit<CR>]], { pattern = "man" } )

  -- show cursorline only in active window
  autocmd({ "InsertLeave", "WinEnter" }, "set cursorline")
  autocmd({ "InsertEnter", "WinLeave" }, "set nocursorline")

  autocmd("User", function(event)
      local fallback_name = vim.api.nvim_buf_get_name(event.buf)
      local fallback_ft = vim.api.nvim_buf_get_option(event.buf, "filetype")
      local fallback_on_empty = fallback_name == "" and fallback_ft == ""

      if fallback_on_empty then
        vim.api.nvim_command("Alpha")
        vim.api.nvim_command(event.buf .. "bwipeout")
      end
    end,
    { pattern = "BDeletePost*" }
  )
end)
