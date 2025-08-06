local wk = require("which-key")
local utils = require("kd.utils")
local noremap = utils.noremap
local nnoremap = utils.nnoremap
local vnoremap = utils.vnoremap
local inoremap = utils.inoremap
local nmap = utils.nmap
local map = utils.map
local command = utils.command

-- visual shifting (does not exit Visual mode)
vnoremap("<", "<gv")
vnoremap(">", ">gv")
nnoremap(">", ">>_")
nnoremap("<", ">>_")

-- Move to window using the <ctrl> hjkl keys
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window", remap = true })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window", remap = true })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window", remap = true })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window", remap = true })

-- Move Lines
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })

-- move to beginning of the line
noremap("H", "^")

-- move to end of the line
noremap("L", "$")

-- better up/down
nmap("j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
nmap("k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Move visual block
vnoremap("J", ":m '>+1<CR>gv=gv")
vnoremap("K", ":m '<-2<CR>gv=gv")

nnoremap("<backspace>", "<c-^>")

nnoremap("J", "j")
nnoremap("K", "k")

-- copy to the end of line
nnoremap("Y", "y$")

-- kakoune like mapping
noremap("ge", "G$")
noremap("gj", "G")
noremap("gk", "gg")
noremap("gi", "0")
noremap("gh", "^")
noremap("gl", "$")

-- highlight last inserted text
nnoremap("gV", "`[v`]")
-- Select last paste
nnoremap("gp", "'`['.strpart(getregtype(), 0, 1).'`]'", { expr = true })

-- Navigate jump list
nnoremap("g,", "<C-o>")
nnoremap("g.", "<C-i>")

-- Goto file under cursor
noremap("gf", "gF")
noremap("gF", "gf")

-- Macros
nnoremap("Q", "@q")
vnoremap("Q", ":norm @@<CR>")

nnoremap("q:", "<nop>")
nnoremap("q/", "<nop>")
nnoremap("q?", "<nop>")

-- redo
nnoremap("U", "<C-R>")

-- Repurpose cursor keys
nnoremap("<Up>", ":cprevious<CR>", { silent = true })
nnoremap("<Down>", ":cnext<CR>", { silent = true })
nnoremap("<Left>", ":cpfile<CR>", { silent = true })
nnoremap("<Right>", ":cnfile<CR>", { silent = true })

nnoremap("<kPlus>", "<C-a>")
nnoremap("<kMinus>", "<C-x>")
nnoremap("+", "<C-a>")
nnoremap("-", "<C-x>")
vnoremap("+", "g<C-a>gv")
vnoremap("-", "g<C-x>gv")

nmap("<Plug>SpeedDatingFallbackUp", "<Plug>(CtrlXA-CtrlA)")
nmap("<Plug>SpeedDatingFallbackDown", "<Plug>(CtrlXA-CtrlX)")

-- backtick goes to the exact mark location, single quote just the line; swap 'em
nnoremap("`", "'")
nnoremap("'", "`")

-- Opens line below or above the current line
inoremap("<S-CR>", "<C-O>o")
inoremap("<C-CR>", "<C-O>O")

-- Sizing window horizontally
nnoremap("<c-,>", "<C-W><")
nnoremap("<c-.>", "<C-W>>")

inoremap("<C-u>", "<C-<C-O>:call unicode#Fuzzy()<CR>")

-- Clears hlsearch after doing a search, otherwise just does normal <CR> stuff
nnoremap("<CR>", [[{-> v:hlsearch ? ":nohl\<CR>" : "\<CR>"}()]], { expr = true })

nnoremap("<space>", "<nop>", { silent = true })

-- search visually selected text (consistent `*` behaviour)
vnoremap("*", [[y/\V<c-r>=escape(@",'/\')<cr><cr>N]], { silent = true })

-- allow W, Q to be used instead of w and q
command("W", "w")
command("Q", "q", { bang = true })
command("Qa", "qa", { bang = true })

command("LspLog", "edit " .. vim.lsp.get_log_path())

command(
  "Glg",
  "Git! log --graph --pretty=format:'%h - (%ad)%d %s <%an>' --abbrev-commit --date=local <args>",
  { nargs = "*" }
)

nnoremap("<space>", "<NOP>", { silent = true })

nnoremap("<tab>", "<cmd>bnext<CR>", { desc = "Jump to next buffer", silent = true })
nnoremap("<s-tab>", "<cmd>bprevious<CR>", { desc = "Jump to next buffer", silent = true })

nnoremap("<a-s-tab>", ":tabprevious<CR>", { desc = "Jump to next tab", silent = true })
nnoremap("<a-tab>", ":tabnext<CR>", { desc = "Jump to next tab", silent = true })

-- nnoremap("<bs>", "<C-^>", { desc = "Jump to alternate buffer", silent = true })

nnoremap("<Leader><Leader>", ":nohlsearch<CR>", { desc = "Clear Highlighting", silent = true })

vnoremap("<leader>p", "\"+p", { desc = "Paste from clipboard" })
vnoremap("<leader>P", "\"+P", { desc = "Paste from clipboard (before)" })
vnoremap("<leader>y", "\"+y", { desc = "Yank to clipboard" })
vnoremap("<leader>Y", "\"+Y", { desc = "Yank line to clipboard" })
vnoremap("<leader>d", "\"+ygvd", { desc = "Cut line to clipboard" })

nnoremap("<C-w>/", "<cmd>split<CR>", { desc = "Split window horizontally" })
nnoremap("<C-w>\\", "<cmd>vsplit<CR>", { desc = "Split window vertically" })
nnoremap("<C-w>z", "<cmd>call zoom#toggle()<CR>", { desc = "Zoom toggle" })

wk.add({
  { "<leader>w", group = "+windows" },
})
nnoremap("<leader>w/", "<cmd>split<CR>", { desc = "Split window horizontally" })
nnoremap("<leader>w\\", "<cmd>vsplit<CR>", { desc = "Split window vertically" })
nnoremap("<leader>wz", "<cmd>call zoom#toggle()<CR>", { desc = "Zoom toggle" })
nnoremap("<leader>ww", "<C-w>w", { desc = "Switch windows" })
nnoremap("<leader>wq", "<C-w>q", { desc = "Quit a window" })
nnoremap("<leader>wT", "<C-w>T", { desc = "Break out into a new tab" })
nnoremap("<leader>wx", "<C-w>x", { desc = "Swap current with next" })
nnoremap("<leader>w-", "<C-w>-", { desc = "Decrease height" })
nnoremap("<leader>w+", "<C-w>+", { desc = "Increase height" })
nnoremap("<leader>w<lt>", "<C-w><lt>", { desc = "Decrease width" })
nnoremap("<leader>w>", "<C-w>>", { desc = "Increase width" })
nnoremap("<leader>w|", "<C-w>|", { desc = "Max out the width" })
nnoremap("<leader>w=", "<C-w>=", { desc = "Equally high and wide" })
nnoremap("<leader>wh", "<C-w>h", { desc = "Go to the left window" })
nnoremap("<leader>wl", "<C-w>l", { desc = "Go to the right window" })
nnoremap("<leader>wk", "<C-w>k", { desc = "Go to the up window" })
nnoremap("<leader>wj", "<C-w>j", { desc = "Go to the down window" })

wk.add({
  { "<leader>q", group = "+format" },
})
nnoremap("<leader>qt", "<cmd>Tabularize<CR>", { desc = "Tabularize" })

wk.add({
  { "<leader>b", group = "+buffers" },
})
nnoremap("<leader>bd", "<cmd>Bdelete<CR>", { desc = "Delete buffer" })
nnoremap("<leader>bj", "<cmd>TablineBufferNext<CR>", { desc = "Next buffer" })
nnoremap("<leader>bk", "<cmd>TablineBufferPrevious<CR>", { desc = "Previous buffer" })
nnoremap("<leader>bw", "<cmd>BufferWipeout<CR>", { desc = "Previous buffer" })

wk.add({
  { "<leader>g", group = "+git" },
})
nnoremap("<leader>gj", "&diff ? ']c' : '<cmd>lua require\"gitsigns.actions\".next_hunk()<CR>'", { desc = "Next Hunk" })
nnoremap("<leader>gk", "&diff ? ']c' : '<cmd>lua require\"gitsigns.actions\".prev_hunk()<CR>'", { desc = "Prev Hunk" })
nnoremap("<leader>gb", "<Plug>(git-messenger)", { desc = "Git Messanger Blame" })
nnoremap("<leader>gB", "<cmd>Git blame<CR>", { desc = "Git Blame" })
nnoremap("<leader>gp", "<cmd>Git push<CR>", { desc = "Git Push" })
nnoremap("<leader>gP", "<cmd>Git pull<CR>", { desc = "Git Pull" })
nnoremap("<leader>gr", "<cmd>GRemove<CR>", { desc = "Git Remove" })
nnoremap("<leader>gC", "<cmd>Git commit<CR>", { desc = "Git commit" })
nnoremap("<leader>gs", "<cmd>Git<CR>", { desc = "Git Status" })
nnoremap("<leader>gw", "<cmd>Gwrite<CR>", { desc = "Stage" })
nnoremap("<leader>gD", "<cmd>Gdiffsplit<CR>", { desc = "Diff" })

wk.add({
  { "<leader>gd", group = "+git diff" },
})
nnoremap("<leader>gdo", "<cmd>DiffviewOpen<CR>", { desc = "Diff ALL" })
nnoremap("<leader>gdh", "<cmd>DiffviewFileHistory<cr>", { desc = "Repo history" })
nnoremap("<leader>gdu", ":diffupdate<CR>", { desc = "Diff update" })
nnoremap("<leader>gdc", [[/\v^[<=>]{7}( .*\|$)<CR>]], { desc = "Show commit markers" })

wk.add({
  { "<leader>gh", group = "+git hunk" },
})
nnoremap("<leader>ghs", "<cmd>lua require\"gitsigns\".stage_hunk()<CR>", { desc = "Stage Hunk" })
nnoremap("<leader>ghu", "<cmd>lua require\"gitsigns\".undo_stage_hunk()<CR>", { desc = "Undo Stage Hunk" })
nnoremap("<leader>ghr", "<cmd>lua require\"gitsigns\".reset_hunk()<CR>", { desc = "Reset Hunk" })
nnoremap("<leader>ghR", "<cmd>lua require\"gitsigns\".reset_buffer()<CR>", { desc = "Reset Buffer" })
nnoremap("<leader>ghp", "<cmd>lua require\"gitsigns\".preview_hunk()<CR>", { desc = "Preview Hunk" })
nnoremap("<leader>ghb", "<cmd>lua require\"gitsigns\".blame_line(true)<CR>", { desc = "Blame line" })

wk.add({
  { "<leader>gf", group = "+git fuzzy" },
})
nnoremap("<leader>gfs", function()
  require("fzf-lua").git_status({})
end, { desc = "Git Status" })
nnoremap("<leader>gfS", function()
  require("fzf-lua").git_stash({})
end, { desc = "Git Stash" })
nnoremap("<leader>gfc", function()
  require("fzf-lua").git_commits({})
end, { desc = "Git Commits" })
nnoremap("<leader>gfb", function()
  require("fzf-lua").git_bcommits({})
end, { desc = "Git Buffer Commits" })
nnoremap("<leader>gfr", function()
  require("fzf-lua").git_branches({})
end, {
  desc = "Git Branches",
})

wk.add({
  { "<leader>s", group = "+sessions" },
})
nnoremap("<leader>ss", ":SaveSession<CR>", { desc = "Save Session" })
nnoremap("<leader>sL", ":SearchSession<CR>", { desc = "Search Session" })
nnoremap("<leader>sl", ":silent! bufdo Bdelete<CR>:silent! RestoreSession<CR>", { desc = "Load Session" })

wk.add({
  { "<leader>d", group = "+debug" },
})
wk.add({
  { "<leader>ds", group = "+debug step" },
})
nnoremap("<leader>dsu", "<cmd>lua require\"dap\".step_over()<CR>", { desc = "Step Over" })
nnoremap("<leader>dsi", "<cmd>lua require\"dap\".step_into()<CR>", { desc = "Step Into" })
nnoremap("<leader>dso", "<cmd>lua require\"dap\".step_out()<CR>", { desc = "Step Out" })
nnoremap("<leader>dsv", "<cmd>lua require\"dap.ui.variables\".scopes()<CR>", { desc = "Variable Scopes" })

wk.add({
  { "<leader>dsb", group = "+debug step breakpoint" },
})
nnoremap(
  "<leader>dsbr",
  "<cmd>lua require\"dap\".set_breakpoint(vim.fn.input(\"Breakpoint condition: \"))<CR>",
  { desc = "Set Breakpoint condition" }
)
nnoremap("<leader>dsc", "<cmd>lua require\"dap\".continue()<CR>", { desc = "Continue" })
nnoremap(
  "<leader>dsbm",
  "<cmd>lua require\"dap\".set_breakpoint(nil, nil, vim.fn.input(\"Log point message: \"))<CR>",
  { desc = "Set Breakpoint log point" }
)
nnoremap("<leader>dsbt", "<cmd>lua require\"dap\".toggle_breakpoint()<CR>", { desc = "Toggle Breakpoint" })

wk.add({
  { "<leader>dh", group = "+debug hover" },
})
nnoremap("<leader>dhh", "<cmd>lua require\"dap.ui.variables\".hover()<CR>", { desc = "Variable Hover" })
nnoremap("<leader>dhv", "<cmd>lua require\"dap.ui.variables\".visual_hover()<CR>", { desc = "Variable Visual Hover" })
nnoremap("<leader>dhu", "<cmd>lua require\"dap.ui.widgets\".hover()<CR>", { desc = "Widget Hover" })
nnoremap(
  "<leader>dhf",
  "<cmd>lua require\"dap.ui.widgets\".centered_float(widgets.scopes)<CR>",
  { desc = "Widgets Centered Float Scopes" }
)

wk.add({
  { "<leader>dr", group = "+debug repl" },
})
nnoremap("<leader>dro", "<cmd>lua require\"dap\".repl.open()<CR>", { desc = "REPL Open" })
nnoremap("<leader>drl", "<cmd>lua require\"dap\".repl.run_last()<CR>", { desc = "REPL run last" })

wk.add({
  { "<leader>f", group = "+fuzzy" },
})
nnoremap("<leader>f.", "<cmd>lua require 'fzf-lua'.resume()<cr>")
nnoremap("<leader>fr", "<cmd>lua require 'fzf-lua'.registers{}<CR>", {
  desc = "Registers",
})
nnoremap("<leader>fk", "<cmd>lua require 'fzf-lua'.keymaps{}<CR>", {
  desc = "Keymaps",
})
nnoremap("<leader>fB", function()
  require("fzf-lua").blines({})
end, {
  desc = "Current Buffer",
})
nnoremap("<Leader>fb", function()
  require("fzf-lua").buffers({
    -- attach_mappings = function(_, map)
    --   map("i", "<C-d>", actions.delete_buffer)
    --   return true
    -- end,
  })
end, {
  desc = "Buffers",
})
nnoremap("<leader>ff", function(opts)
  opts = opts or {}
  require("fzf-lua").files(opts)
end, {
  desc = "Files",
  silent = true,
})
nnoremap("<leader>f:", function()
  require("fzf-lua").command_history({})
end, {
  desc = "Command History",
  silent = true,
})
nnoremap("<leader>fg", function(opts)
  opts = opts or {}
  local function is_git_repo()
    vim.fn.system("git rev-parse --is-inside-work-tree")

    return vim.v.shell_error == 0
  end

  local function get_git_root()
    local dot_git_path = vim.fn.finddir(".git", ".;")
    return vim.fn.fnamemodify(dot_git_path, ":h")
  end

  if is_git_repo() then
    opts = {
      cwd = get_git_root(),
    }
  end
  require("fzf-lua").live_grep(opts)
end, {
  desc = "Live Grep",
  silent = true,
})
vnoremap("<leader>fw", function(opts)
  opts = opts or {}
  require("fzf-lua").grep_visual(opts)
end, {
  desc = "Grep String",
  silent = true,
})
nnoremap("<leader>fw", function(opts)
  opts = opts or {}
  require("fzf-lua").grep_cword(opts)
end, {
  desc = "Grep String",
  silent = true,
})
nnoremap("<leader>fW", function(opts)
  opts = opts or {}
  require("fzf-lua").grep_cWORD(opts)
end, {
  desc = "Grep String",
  silent = true,
})
nnoremap("<leader>fh", function()
  require("fzf-lua").help_tags()
end, {
  desc = "Help Tags",
})
nnoremap("<leader>fm", function()
  require("fzf-lua").man_pages({ sections = { "ALL" } })
end, {
  desc = "Man pages",
})
nnoremap("<leader>fs", function()
  require("fzf-lua").spell_suggest()
end, {
  desc = "Spell suggest",
})

wk.add({
  { "<leader>l", group = "+lsp" },
})
nnoremap("<leader>lr", function()
  require("fzf-lua").lsp_references({})
end, { desc = "LSP References" })
nnoremap("<leader>ld", function()
  require("fzf-lua").lsp_definitions({})
end, {
  desc = "LSP Definitions",
})
nnoremap("<leader>lD", function()
  require("fzf-lua").lsp_declarations({})
end, {
  desc = "LSP Declarations",
})
nnoremap("<leader>li", function()
  require("fzf-lua").lsp_implementations({})
end, { desc = "Implementation" })
nnoremap("<leader>ls", function()
  require("fzf-lua").lsp_workspace_symbols({})
end, {
  desc = "Workspace Symbols",
})
nnoremap("<leader>lS", function()
  require("fzf-lua").lsp_live_workspace_symbols({})
end, {
  desc = "Live Workspace Symbols",
})
nnoremap("<leader>lt", function()
  require("fzf-lua").lsp_typedefs({})
end, {
  desc = "Type definitions",
})
nnoremap("<leader>lca", function()
  require("fzf-lua").lsp_code_actions({})
end, { desc = "Code Action" })

nnoremap("<leader>lh", function()
  -- instead of vim.lsp.buf.hover()
  -- solves issue where line_diagnostics would hide hover info because of CursorHold autocmd
  vim.api.nvim_command("set eventignore=CursorHold")
  vim.api.nvim_command("autocmd CursorMoved <buffer> ++once set eventignore=\"\"")
  vim.lsp.buf.hover()
end, {
  desc = "Hover Documentation",
})
nnoremap("<leader>lH", function()
  -- instead of vim.lsp.buf.signature_help()
  -- solves issue where line_diagnostics would hide hover info because of CursorHold autocmd
  vim.api.nvim_command("set eventignore=CursorHold")
  vim.api.nvim_command("autocmd CursorMoved <buffer> ++once set eventignore=\"\"")
  vim.lsp.buf.signature_help()
end, {
  desc = "Signature Documentation",
})
nnoremap("<leader>lg", function()
  -- focus into diagnostic
  vim.api.nvim_command("set eventignore=WinLeave")
  vim.api.nvim_command("autocmd CursorMoved <buffer> ++once set eventignore=\"\"")
  vim.diagnostic.open_float(nil, {
    focusable = true,
    scope = "line",
    close_events = { "CursorMoved", "CursorMovedI", "BufHidden", "InsertCharPre", "WinLeave" },
  })
end, {
  desc = "Line Diagnostics",
})

-- Lesser used LSP functionality
nnoremap("<leader>lwa", vim.lsp.buf.add_workspace_folder, { desc = "Workspace Add Folder" })
nnoremap("<leader>lwr", vim.lsp.buf.remove_workspace_folder, { desc = "Workspace Remove Folder" })
nnoremap("<leader>lwl", function()
  print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
end, { desc = "Workspace List Folders" })

nnoremap("<leader>lG", function()
  require("fzf-lua").lsp_workspace_diagnostics({})
end, { desc = "Workspace Diagnostics" })
-- nnoremap("<leader>l]", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", { desc = "Next Diagnostic" })
-- nnoremap("<leader>l[", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", { desc = "Previous Diagnostic" })
nnoremap("<leader>ll", "<cmd>Trouble<CR>", { desc = "Trouble" })
nnoremap("<leader>lR", "<cmd>lua vim.lsp.buf.rename()<CR>", { desc = "Rename" })

nnoremap("<leader>lf", function()
  require("fzf-lua").lsp_finder({})
end, { desc = "LSP Finder" })

wk.add({ { "<leader>lc", group = "+lsp calls" } })
nnoremap("<leader>lco", "<cmd>lua vim.lsp.buf.outgoing_calls()<CR>", { desc = "Outgoing calls" })
nnoremap("<leader>lci", "<cmd>lua vim.lsp.buf.incoming_calls()<CR>", { desc = "Incoming calls" })

wk.add({ { "<leader>v", group = "+neovim" } })
nnoremap("<leader>vm", "<cmd>TSHighlightCapturesUnderCursor<CR>", { desc = "Show highlights under cursor" })
nnoremap("<leader>ve", "<cmd>e $MYVIMRC<CR>", { desc = "Open VIMRC" })
nnoremap("<leader>vs", "<cmd>luafile $MYVIMRC<CR>", { desc = "Source VIMRC" })
nnoremap("<leader>vz", "<cmd>e ~/.zshrc<CR>", { desc = "Open ZSHRC" })
nnoremap("<leader>v:", function()
  require("fzf-lua").commands()
end, { desc = "Vim commands" })
nnoremap("<Leader>vv", function()
  require("fzf-lua").files({
    cwd = "~/.config/nvim",
  })
end, {
  desc = "Search neovim config files",
  silent = true,
})
nnoremap("<Leader>v.", function()
  require("fzf-lua").files({
    cwd = "~/gitrepos/dotfiles",
  })
end, {
  desc = "Search dotfiles",
  silent = true,
})
nnoremap("<Leader>vg", function()
  require("fzf-lua").files({
    cwd = "~/gitrepos",
  })
end, {
  desc = "Search git repos",
  silent = true,
})

-- Diagnostic keymaps
wk.add({
  { "<leader>d", group = "+diagnostic" },
})
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
map("n", "<leader>de", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
map("n", "<leader>dq", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

nnoremap("-", "<cmd>Oil<CR>", { desc = "Open parent directory" })
