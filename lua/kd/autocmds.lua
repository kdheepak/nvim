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
      "null-ls-info",
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

  autocmd("User", function(event)
    local fallback_name = vim.api.nvim_buf_get_name(event.buf)
    local fallback_ft = vim.api.nvim_buf_get_option(event.buf, "filetype")
    local fallback_on_empty = fallback_name == "" and fallback_ft == ""

    if fallback_on_empty then
      vim.api.nvim_command("Alpha")
      vim.api.nvim_command(event.buf .. "bwipeout")
    end
  end, { pattern = "BDeletePost*" })

  -- LuaSnip Snippet History Fix
  autocmd("ModeChanged", function()
    if
      ((vim.v.event.old_mode == "s" and vim.v.event.new_mode == "n") or vim.v.event.old_mode == "i")
      and require("luasnip").session.current_nodes[vim.api.nvim_get_current_buf()]
      and not require("luasnip").session.jump_active
    then
      require("luasnip").unlink_current()
    end
  end)

  autocmd("FileType", "lua vim.opt.conceallevel = 0", { pattern = { "help" } })

  autocmd("CursorHold", function()
    vim.diagnostic.open_float(nil, {
      scope = "cursor",
      focusable = false,
      close_events = {
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

  autocmd("BufEnter", function()
    local stats = vim.loop.fs_stat(vim.api.nvim_buf_get_name(0))
    if stats and stats.type == "directory" then
      require("neo-tree")
    end
  end, {
    desc = "Open Neo-Tree on startup with directory",
  })

  autocmd("VimEnter", function()
    local should_skip = false
    if vim.fn.argc() > 0 or vim.fn.line2byte(vim.fn.line("$")) ~= -1 or not vim.o.modifiable then
      should_skip = true
    else
      for _, arg in pairs(vim.v.argv) do
        if arg == "-b" or arg == "-c" or vim.startswith(arg, "+") or arg == "-S" then
          should_skip = true
          break
        end
      end
    end
    if not should_skip then
      require("telescope.builtin").find_files()
    end
  end, {
    desc = "Start fuzzy file search when vim is opened with no arguments",
  })

  autocmd("TermOpen", "setlocal listchars= nonumber norelativenumber nocursorline")
  autocmd({ "WinEnter", "BufWinEnter", "TermOpen" }, function(args)
    if vim.startswith(vim.api.nvim_buf_get_name(args.buf), "term://") then
      vim.opt_local.wrap = true
      vim.opt_local.spell = false
      vim.cmd("startinsert")
      local opts = { noremap = true }
      vim.api.nvim_buf_set_keymap(args.buf, "t", "<esc>", [[<C-\><C-n>]], opts)
      vim.api.nvim_buf_set_keymap(args.buf, "t", "<leader>wh", [[<C-\><C-n><C-W>h]], opts)
      vim.api.nvim_buf_set_keymap(args.buf, "t", "<leader>wj>", [[<C-\><C-n><C-W>j]], opts)
      vim.api.nvim_buf_set_keymap(args.buf, "t", "<leader>wk>", [[<C-\><C-n><C-W>k]], opts)
      vim.api.nvim_buf_set_keymap(args.buf, "t", "<leader>wl>", [[<C-\><C-n><C-W>l]], opts)
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
