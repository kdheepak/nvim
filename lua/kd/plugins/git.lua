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
  -- {
  --   "whiteinge/diffconflicts",
  --   config = function()
  --     vim.cmd([[
  --         " Disable one diff window during a three-way diff allowing you to cut out the
  --         " noise of a three-way diff and focus on just the changes between two versions
  --         " at a time. Inspired by Steve Losh's Splice
  --         function! DiffToggle(window)
  --         " Save the cursor position and turn on diff for all windows
  --         let l:save_cursor = getpos('.')
  --         windo :diffthis
  --         " Turn off diff for the specified window (but keep scrollbind) and move
  --         " the cursor to the left-most diff window
  --         exe a:window . "wincmd w"
  --         diffoff
  --         set scrollbind
  --         set cursorbind
  --         exe a:window . "wincmd " . (a:window == 1 ? "l" : "h")
  --         " Update the diff and restore the cursor position
  --         diffupdate
  --         call setpos('.', l:save_cursor)
  --         endfunction
  --
  --         " Toggle diff view on the left, center, or right windows
  --         nmap <silent> <leader>dl :call DiffToggle(1)<cr>
  --         nmap <silent> <leader>dc :call DiffToggle(2)<cr>
  --         nmap <silent> <leader>dr :call DiffToggle(3)<cr>
  --         ]])
  --   end,
  --   event = "BufRead",
  -- },
  {
    "akinsho/git-conflict.nvim",
    config = function()
      require("git-conflict").setup({
        default_mappings = false,
      })
      local utils = require("kd.utils")
      local nnoremap = utils.nnoremap
      nnoremap("<leader>gco", "<Plug>(git-conflict-ours)", { desc = "Git choose ours" })
      nnoremap("<leader>gct", "<Plug>(git-conflict-theirs)", { desc = "Git choose theirs" })
      nnoremap("<leader>gcb", "<Plug>(git-conflict-both)", { desc = "Git choose both" })
      nnoremap("<leader>gcn", "<Plug>(git-conflict-none)", { desc = "Git choose ignore both" })
      nnoremap("]c", "<Plug>(git-conflict-next-conflict)", { desc = "Jump to next git conflict" })
      nnoremap("[c", "<Plug>(git-conflict-prev-conflict)", { desc = "Jump to previous git conflict" })
    end,
  },
  {
    "ruifm/gitlinker.nvim",
    dependencies = "nvim-lua/plenary.nvim",
  },
  {
    "pwntester/octo.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    cmd = {
      "Octo",
    },
    config = function()
      local octo = require("octo")

      octo.setup({
        mappings = {
          issue = {
            close_issue = { lhs = "<LocalLeader>ic", desc = "close issue" },
            reopen_issue = { lhs = "<LocalLeader>io", desc = "reopen issue" },
            list_issues = { lhs = "<LocalLeader>il", desc = "list open issues on same repo" },
            reload = { lhs = "R", desc = "reload issue" },
            open_in_browser = { lhs = "B", desc = "open issue in browser" },
            copy_url = { lhs = "<C-y>", desc = "copy url to system clipboard" },
            add_assignee = { lhs = "<LocalLeader>aa", desc = "add assignee" },
            remove_assignee = { lhs = "<LocalLeader>ad", desc = "remove assignee" },
            create_label = { lhs = "<LocalLeader>lc", desc = "create label" },
            add_label = { lhs = "<LocalLeader>la", desc = "add label" },
            remove_label = { lhs = "<LocalLeader>ld", desc = "remove label" },
            goto_issue = { lhs = "<LocalLeader>gi", desc = "navigate to a local repo issue" },
            add_comment = { lhs = "<LocalLeader>ca", desc = "add comment" },
            delete_comment = { lhs = "<LocalLeader>cd", desc = "delete comment" },
            next_comment = { lhs = "]c", desc = "go to next comment" },
            prev_comment = { lhs = "[c", desc = "go to previous comment" },
            react_hooray = { lhs = "<LocalLeader>rp", desc = "add/remove 🎉 reaction" },
            react_heart = { lhs = "<LocalLeader>rh", desc = "add/remove ❤️ reaction" },
            react_eyes = { lhs = "<LocalLeader>re", desc = "add/remove 👀 reaction" },
            react_thumbs_up = { lhs = "<LocalLeader>r+", desc = "add/remove 👍 reaction" },
            react_thumbs_down = { lhs = "<LocalLeader>r-", desc = "add/remove 👎 reaction" },
            react_rocket = { lhs = "<LocalLeader>rr", desc = "add/remove 🚀 reaction" },
            react_laugh = { lhs = "<LocalLeader>rl", desc = "add/remove 😄 reaction" },
            react_confused = { lhs = "<LocalLeader>rc", desc = "add/remove 😕 reaction" },
          },
          pull_request = {
            checkout_pr = { lhs = "<LocalLeader>po", desc = "checkout PR" },
            merge_pr = { lhs = "<LocalLeader>pMm", desc = "merge commit PR" },
            squash_and_merge_pr = { lhs = "<LocalLeader>pMs", desc = "squash and merge PR" },
            list_commits = { lhs = "<LocalLeader>pc", desc = "list PR commits" },
            list_changed_files = { lhs = "<LocalLeader>pf", desc = "list PR changed files" },
            show_pr_diff = { lhs = "<LocalLeader>pd", desc = "show PR diff" },
            add_reviewer = { lhs = "<LocalLeader>va", desc = "add reviewer" },
            remove_reviewer = { lhs = "<LocalLeader>vd", desc = "remove reviewer request" },
            close_issue = { lhs = "<LocalLeader>pmc", desc = "close PR" },
            reopen_issue = { lhs = "<LocalLeader>pmo", desc = "reopen PR" },
            list_issues = { lhs = "<LocalLeader>il", desc = "list open issues on same repo" },
            reload = { lhs = "R", desc = "reload PR" },
            open_in_browser = { lhs = "B", desc = "open PR in browser" },
            copy_url = { lhs = "<C-y>", desc = "copy url to system clipboard" },
            goto_file = { lhs = "gf", desc = "go to file" },
            add_assignee = { lhs = "<LocalLeader>aa", desc = "add assignee" },
            remove_assignee = { lhs = "<LocalLeader>ad", desc = "remove assignee" },
            create_label = { lhs = "<LocalLeader>lc", desc = "create label" },
            add_label = { lhs = "<LocalLeader>la", desc = "add label" },
            remove_label = { lhs = "<LocalLeader>ld", desc = "remove label" },
            goto_issue = { lhs = "<LocalLeader>gi", desc = "navigate to a local repo issue" },
            add_comment = { lhs = "<LocalLeader>ca", desc = "add comment" },
            delete_comment = { lhs = "<LocalLeader>cd", desc = "delete comment" },
            next_comment = { lhs = "]c", desc = "go to next comment" },
            prev_comment = { lhs = "[c", desc = "go to previous comment" },
            react_hooray = { lhs = "<LocalLeader>rp", desc = "add/remove 🎉 reaction" },
            react_heart = { lhs = "<LocalLeader>rh", desc = "add/remove ❤️ reaction" },
            react_eyes = { lhs = "<LocalLeader>re", desc = "add/remove 👀 reaction" },
            react_thumbs_up = { lhs = "<LocalLeader>r+", desc = "add/remove 👍 reaction" },
            react_thumbs_down = { lhs = "<LocalLeader>r-", desc = "add/remove 👎 reaction" },
            react_rocket = { lhs = "<LocalLeader>rr", desc = "add/remove 🚀 reaction" },
            react_laugh = { lhs = "<LocalLeader>rl", desc = "add/remove 😄 reaction" },
            react_confused = { lhs = "<LocalLeader>rc", desc = "add/remove 😕 reaction" },
          },
          review_thread = {
            goto_issue = { lhs = "<LocalLeader>gi", desc = "navigate to a local repo issue" },
            add_comment = { lhs = "<LocalLeader>ca", desc = "add comment" },
            delete_comment = { lhs = "<LocalLeader>cd", desc = "delete comment" },
            add_suggestion = { lhs = "<LocalLeader>sa", desc = "add suggestion" },
            next_comment = { lhs = "]c", desc = "go to next comment" },
            prev_comment = { lhs = "[c", desc = "go to previous comment" },
            select_next_entry = { lhs = "]q", desc = "move to previous changed file" },
            select_prev_entry = { lhs = "[q", desc = "move to next changed file" },
            close_review_tab = { lhs = "<C-c>", desc = "close review tab" },
            react_hooray = { lhs = "<LocalLeader>rp", desc = "add/remove 🎉 reaction" },
            react_heart = { lhs = "<LocalLeader>rh", desc = "add/remove ❤️ reaction" },
            react_eyes = { lhs = "<LocalLeader>re", desc = "add/remove 👀 reaction" },
            react_thumbs_up = { lhs = "<LocalLeader>r+", desc = "add/remove 👍 reaction" },
            react_thumbs_down = { lhs = "<LocalLeader>r-", desc = "add/remove 👎 reaction" },
            react_rocket = { lhs = "<LocalLeader>rr", desc = "add/remove 🚀 reaction" },
            react_laugh = { lhs = "<LocalLeader>rl", desc = "add/remove 😄 reaction" },
            react_confused = { lhs = "<LocalLeader>rc", desc = "add/remove 😕 reaction" },
          },
          submit_win = {
            approve_review = { lhs = "<LocalLeader>sa", desc = "approve review" },
            comment_review = { lhs = "<LocalLeader>sc", desc = "comment review" },
            request_changes = { lhs = "<LocalLeader>sr", desc = "request changes review" },
            close_review_tab = { lhs = "<LocalLeader>sx", desc = "close review tab" },
          },
          review_diff = {
            add_review_comment = { lhs = "<LocalLeader>ca", desc = "add a new review comment" },
            add_review_suggestion = { lhs = "<LocalLeader>sa", desc = "add a new review suggestion" },
            focus_files = { lhs = "<LocalLeader>e", desc = "move focus to changed file panel" },
            toggle_files = { lhs = "<LocalLeader>b", desc = "hide/show changed files panel" },
            next_thread = { lhs = "]t", desc = "move to next thread" },
            prev_thread = { lhs = "[t", desc = "move to previous thread" },
            select_next_entry = { lhs = "]q", desc = "move to previous changed file" },
            select_prev_entry = { lhs = "[q", desc = "move to next changed file" },
            close_review_tab = { lhs = "<C-c>", desc = "close review tab" },
            toggle_viewed = { lhs = "<LocalLeader><space>", desc = "toggle viewer viewed state" },
            goto_file = { lhs = "gf", desc = "go to file" },
          },
          file_panel = {
            next_entry = { lhs = "j", desc = "move to next changed file" },
            prev_entry = { lhs = "k", desc = "move to previous changed file" },
            select_entry = { lhs = "<cr>", desc = "show selected changed file diffs" },
            refresh_files = { lhs = "R", desc = "refresh changed files panel" },
            focus_files = { lhs = "<LocalLeader>e", desc = "move focus to changed file panel" },
            toggle_files = { lhs = "<LocalLeader>b", desc = "hide/show changed files panel" },
            select_next_entry = { lhs = "]q", desc = "move to previous changed file" },
            select_prev_entry = { lhs = "[q", desc = "move to next changed file" },
            close_review_tab = { lhs = "<C-c>", desc = "close review tab" },
            toggle_viewed = { lhs = "<LocalLeader><Space>", desc = "toggle viewer viewed state" },
          },
        },
      })

      -- Main Octo buffer
      local function attach_octo(bufnr)
        wk.register({
          a = { name = "Assignee" },
          c = { name = "Comment" },
          g = { name = "Go To" },
          i = { name = "Issue" },
          l = { name = "Label" },
          p = {
            name = "Pull Request",
            r = { "<cmd>Octo pr ready<CR>", "mark draft as ready to review" },
            s = { "<cmd>Octo pr checks<CR>", "status of all checks" },
            m = { name = "Manage pull request" },
            M = { name = "Merge" },
          },
          r = { name = "Reaction" },
          s = { name = "Submit" },
          v = { name = "Reviewer" },
          R = {
            name = "Review",
            s = { "<cmd>Octo review start<CR>", "start review" },
            r = { "<cmd>Octo review resume<CR>", "resume" },
            m = {
              name = "Manage review",
              d = { "<cmd>Octo review discard<CR>", "delete pending review" },
              s = { "<cmd>Octo review submit<CR>", "submit review" },
              c = { "<cmd>Octo review comments<CR>", "view pending comments" },
              p = { "<cmd>Octo review commit<CR>", "pick a commit" },
            },
          },
        }, {
          buffer = bufnr,
          mode = "n", -- NORMAL mode
          prefix = "<LocalLeader>",
          silent = true, -- use `silent` when creating keymaps
          noremap = true, -- use `noremap` when creating keymaps
          nowait = false, -- use `nowait` when creating keymaps
        })
      end
    end,
  },
}
