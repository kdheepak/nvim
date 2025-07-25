vim.cmd("syntax enable")
vim.cmd("syntax on")
vim.cmd("filetype indent on")

vim.o.undodir = vim.fn.stdpath("cache") .. "/undodir"
vim.o.backupdir = vim.fn.stdpath("cache") .. "/backup"
vim.o.directory = vim.fn.stdpath("cache") .. "/swap"
vim.o.undofile = true

vim.o.encoding = "utf-8" -- Default file encoding
vim.o.autochdir = false --  Don't change dirs automatically
vim.o.errorbells = false --  No sound

vim.o.shiftround = true
vim.o.expandtab = true --  Expand tab to spaces
vim.o.timeoutlen = 500 --  Wait less time for mapped sequences
vim.o.smarttab = true --  <TAB> in front of line inserts blanks according to shiftwidth
vim.o.shiftwidth = 4

vim.o.showbreak = "↪ " --  string to put at the start of lines that have been wrapped
vim.o.breakindent = true --  every wrapped line will continue visually indented
vim.o.linebreak = true --  wrap long lines at a character in breakat
vim.o.wrap = false --  lines longer than the width of the window will not wrap

vim.o.termguicolors = true --  enables 24bit colors
vim.o.visualbell = false --  don't display visual bell
vim.o.showmode = false --  don't show mode changes
vim.o.diffopt = vim.o.diffopt .. ",vertical" --  Always use vertical diffs
vim.o.diffopt = vim.o.diffopt .. ",algorithm:patience"
vim.o.diffopt = vim.o.diffopt .. ",indent-heuristic"
vim.o.cursorline = true --  highlight current line
vim.o.showcmd = true --  show command in bottom bar display an incomplete command in the lower right of the vim window
vim.o.showmatch = true --  highlight matching [{()}]
-- vim.o.lazyredraw = true --  redraw only when we need to.
vim.o.ignorecase = true --  Ignore case when searching
vim.o.smartcase = true --  When searching try to be smart about cases
vim.o.incsearch = true --  search as characters are entered
vim.o.hlsearch = true --  highlight matches
vim.o.inccommand = "split" --  live search and replace

vim.o.wildmenu = true --  visual autocomplete for command menu
vim.o.autoread = true --  automatically read files that have been changed outside of vim
vim.o.emoji = false --  emoji characters are not considered full width
vim.o.backup = false --  no backup before overwriting a file
vim.o.writebackup = false --  no backups when writing a file
vim.o.autowrite = true --  Automatically :write before running commands
vim.o.list = true
vim.o.listchars = "tab:»·,trail:·,nbsp:×,extends:❯,precedes:❮" --  Display extra whitespace
vim.o.nrformats = "bin,hex,alpha" --  increment or decrement alpha
vim.o.mouse = "a" --  Enables mouse support
vim.o.foldenable = false --  disable folding
vim.o.signcolumn = "yes" --  Always show git gutter / sign column
vim.o.joinspaces = false --  Use one space, not two, after punctuation
vim.o.splitright = true --  split windows right
vim.o.splitbelow = true --  split windows below
vim.o.viminfo = vim.o.viminfo .. ",n" .. vim.fn.stdpath("cache") .. "/viminfo"
-- vim.o.virtualedit = vim.o.virtualedit .. "all" --  allow virtual editing in all modes
vim.o.modeline = false --  no lines are checked for set commands
vim.o.grepprg = "rg --vimgrep" --  use ripgrep
vim.o.redrawtime = 10000 -- set higher redrawtime so that vim does not hang on difficult syntax highlighting
vim.o.updatetime = 250 -- set lower updatetime so that vim git gutter updates sooner
vim.o.switchbuf = vim.o.switchbuf .. ",useopen" --  open buffers in tab

vim.o.shortmess = "filnxtToOfcI" --  Shut off completion and intro messages
vim.o.scrolloff = 100000 -- always cursor in the middle
vim.o.number = true
vim.o.relativenumber = true
vim.o.sessionoptions = vim.o.sessionoptions .. ",globals"
vim.o.hidden = true
vim.o.autoread = true
vim.opt.laststatus = 3

vim.g.markdown_fenced_languages = { "html", "python", "rust", "julia", "vim" }
