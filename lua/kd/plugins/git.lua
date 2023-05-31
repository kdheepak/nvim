return {
  -- Git related plugins
  { "tpope/vim-fugitive" },
  { "tpope/vim-rhubarb" },
  {
    "ruanyl/vim-gh-line",
    config = function()
      vim.g.gh_line_map = "<leader>go"
      vim.g.gh_line_blame_map = "<leader>gb"
    end,
  },
  {
    "whiteinge/diffconflicts",
    config = function()
      vim.cmd([[
          " Disable one diff window during a three-way diff allowing you to cut out the
          " noise of a three-way diff and focus on just the changes between two versions
          " at a time. Inspired by Steve Losh's Splice
          function! DiffToggle(window)
          " Save the cursor position and turn on diff for all windows
          let l:save_cursor = getpos('.')
          windo :diffthis
          " Turn off diff for the specified window (but keep scrollbind) and move
          " the cursor to the left-most diff window
          exe a:window . "wincmd w"
          diffoff
          set scrollbind
          set cursorbind
          exe a:window . "wincmd " . (a:window == 1 ? "l" : "h")
          " Update the diff and restore the cursor position
          diffupdate
          call setpos('.', l:save_cursor)
          endfunction

          " Toggle diff view on the left, center, or right windows
          nmap <silent> <leader>dl :call DiffToggle(1)<cr>
          nmap <silent> <leader>dc :call DiffToggle(2)<cr>
          nmap <silent> <leader>dr :call DiffToggle(3)<cr>
          ]])
    end,
    event = "BufRead",
  },
  {
    "akinsho/git-conflict.nvim",
    config = true,
  },
  {
    "ruifm/gitlinker.nvim",
    dependencies = "nvim-lua/plenary.nvim",
  },
}
