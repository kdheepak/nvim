local utils = require("kd/utils")
local cnoremap = utils.cnoremap
local noremap = utils.noremap
local nnoremap = utils.nnoremap
local vnoremap = utils.vnoremap
local inoremap = utils.inoremap
local nmap = utils.nmap
local command = utils.command

cnoremap("<C-k>", "pumvisible() ? \"<C-p>\"  : \"<Up>\"")
cnoremap("<C-j>", "pumvisible() ? \"<C-n>\"  : \"<Down>\"")

-- Use virtual replace mode all the time
nnoremap("r", "gr")
nnoremap("R", "gR")

-- visual shifting (does not exit Visual mode)
vnoremap("<", "<gv")
vnoremap(">", ">gv")
nnoremap(">", ">>_")
nnoremap("<", ">>_")

-- highlight last inserted text
nnoremap("gV", "`[v`]")

-- move vertically by visual line
nnoremap("j", "gj")
nnoremap("k", "gk")

-- move vertically by actual line
nnoremap("J", "j")
nnoremap("K", "k")

-- move to beginning of the line
noremap("H", "^")

-- move to end of the line
noremap("L", "$")

-- Move visual block
vnoremap("J", ":m '>+1<CR>gv=gv")
vnoremap("K", ":m '<-2<CR>gv=gv")

-- copy to the end of line
nnoremap("Y", "y$")

-- kakoune like mapping
noremap("ge", "G$")
noremap("gj", "G")
noremap("gk", "gg")
noremap("gi", "0")
noremap("gh", "^")
noremap("gl", "$")
noremap("ga", "<C-^>")

-- move through wrapped lines
nnoremap("j", "gj")
nnoremap("k", "gk")

-- Navigate jump list
nnoremap("g,", "<C-o>")
nnoremap("g.", "<C-i>")

-- Goto file under cursor
noremap("gf", "gF")
noremap("gF", "gf")

nnoremap("<a-s-tab>", ":tabprevious<CR>")
nnoremap("<a-tab>", ":tabnext<CR>")

-- Macros
nnoremap("Q", "@q")
vnoremap("Q", ":norm @@<CR>")

nnoremap("q:", "<nop>")
nnoremap("q/", "<nop>")
nnoremap("q?", "<nop>")

-- Select last paste
nnoremap("gp", "'`['.strpart(getregtype(), 0, 1).'`]'", { expr = true })

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

