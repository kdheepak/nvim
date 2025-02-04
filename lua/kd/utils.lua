local M = {}

function M.feedkeys(key, mode)
  return vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

function M.T(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end
_G.T = M.T

function M.P(...)
  local objects = vim.tbl_map(vim.inspect, { ... })
  print(unpack(objects))
end
_G.P = M.P

function M.prequire(m)
  local ok, err = pcall(require, m)
  if not ok then
    return nil, err
  end
  -- if ok, err == m
  return err
end
_G.prequire = M.prequire

function M.RELOAD(...)
  local plenary_reload = prequire("plenary.reload")
  if plenary_reload then
    return plenary_reload.reload_module(...)
  else
    return require(...)
  end
end
_G.RELOAD = M.RELOAD

function M.R(name)
  RELOAD(name)
  return require(name)
end
_G.R = M.R

function M.augroup(name, callback)
  vim.api.nvim_create_augroup(name, { clear = true })
  M._current_autocmd_group_name = name
  callback()
  M._current_autocmd_group_name = nil
end

function M.autocmd(name, cmd, opts)
  opts = opts or {}
  local cmd_type = type(cmd)
  if cmd_type == "function" then
    opts.callback = cmd
  elseif cmd_type == "string" then
    opts.command = cmd
  else
    error("autocmd(): unsupported cmd type: " .. cmd_type)
  end
  if M._current_autocmd_group_name ~= nil then
    opts.group = M._current_autocmd_group_name
  end
  vim.api.nvim_create_autocmd(name, opts)
end

function M.cnoremap(lhs, rhs, opts)
  opts = opts or {}
  return M.cmap(lhs, rhs, vim.tbl_extend("force", opts, { noremap = true }))
end

function M.inoremap(lhs, rhs, opts)
  opts = opts or {}
  return M.imap(lhs, rhs, vim.tbl_extend("force", opts, { noremap = true }))
end

function M.nnoremap(lhs, rhs, opts)
  opts = opts or {}
  return M.nmap(lhs, rhs, vim.tbl_extend("force", opts, { noremap = true }))
end

function M.tnoremap(lhs, rhs, opts)
  opts = opts or {}
  return M.tmap(lhs, rhs, vim.tbl_extend("force", opts, { noremap = true }))
end

function M.vnoremap(lhs, rhs, opts)
  opts = opts or {}
  return M.vmap(lhs, rhs, vim.tbl_extend("force", opts, { noremap = true }))
end

function M.xnoremap(lhs, rhs, opts)
  opts = opts or {}
  return M.xmap(lhs, rhs, vim.tbl_extend("force", opts, { noremap = true }))
end

function M.snoremap(lhs, rhs, opts)
  opts = opts or {}
  return M.smap(lhs, rhs, vim.tbl_extend("force", opts, { noremap = true }))
end

function M.noremap(lhs, rhs, opts)
  opts = opts or {}
  return M.map("", lhs, rhs, vim.tbl_extend("force", opts, { noremap = true }))
end

function M.cmap(lhs, rhs, opts)
  opts = opts or {}
  return M.map("c", lhs, rhs, opts)
end

function M.imap(lhs, rhs, opts)
  opts = opts or {}
  return M.map("i", lhs, rhs, opts)
end

function M.nmap(lhs, rhs, opts)
  opts = opts or {}
  return M.map("n", lhs, rhs, opts)
end

function M.tmap(lhs, rhs, opts)
  opts = opts or {}
  return M.map("t", lhs, rhs, opts)
end

function M.xmap(lhs, rhs, opts)
  opts = opts or {}
  return M.map("x", lhs, rhs, opts)
end

function M.smap(lhs, rhs, opts)
  opts = opts or {}
  return M.map("s", lhs, rhs, opts)
end

function M.vmap(lhs, rhs, opts)
  opts = opts or {}
  return M.map("v", lhs, rhs, opts)
end

function M.map(mode, lhs, rhs, opts)
  vim.keymap.set(mode, lhs, rhs, opts)
end

function M.join(tbl, delimiter)
  delimiter = delimiter or ""
  local result = ""
  local len = #tbl
  for i, item in ipairs(tbl) do
    if i == len then
      result = result .. item
    else
      result = result .. item .. delimiter
    end
  end
  return result
end

function M.command(name, cmd, opts)
  opts = opts or {}
  vim.api.nvim_create_user_command(name, cmd, opts)
end

function M.strip_trailing_slash(dir)
  if string.sub(dir, -1, -1) == "/" then
    dir = string.sub(dir, 1, -2)
  end
  return dir
end

function M.range(lower, upper)
  local result = {}
  for i = lower, upper do
    table.insert(result, i)
  end
  return result
end

function M.syntax(item, ...)
  local t = { ... }
  local expansion = ""
  for _, s in ipairs(t) do
    expansion = expansion .. " " .. s
  end
  vim.cmd("syntax " .. item .. " " .. expansion)
end

function M.highlight(group, guifg, guibg, ctermfg, ctermbg, attr, guisp)
  if group == "default" and guifg == "link" then
    local lhs = guibg
    local rhs = ctermfg
    vim.cmd("highlight def link " .. lhs .. " " .. rhs)
  else
    attr = attr or ""
    guisp = guisp or ""

    local command = ""

    if guifg ~= "" then
      command = command .. " guifg=#" .. guifg
    end
    if guibg ~= "" then
      command = command .. " guibg=#" .. guibg
    end
    if ctermfg ~= "" then
      command = command .. " ctermfg=" .. ctermfg
    end
    if ctermbg ~= "" then
      command = command .. " ctermbg=" .. ctermbg
    end
    if attr ~= "" then
      command = command .. " gui=" .. attr .. " cterm=" .. attr
    end
    if guisp ~= "" then
      command = command .. " guisp=#" .. guisp
    end

    if command ~= "" then
      vim.cmd("highlight " .. group .. command)
    end
  end
end

M.check_backspace = function()
  local col = vim.fn.col(".") - 1
  return col == 0 or vim.fn.getline("."):sub(col, col):match("%s")
end

M.has_words_before = function()
  if vim.api.nvim_get_option_value("buftype", { buf = 0 }) == "prompt" then
    return false
  end
  local unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

M.get_visual_selection = function()
  vim.cmd([[visual]])
  local _, start_row, start_col, _ = unpack(vim.fn.getpos("'<"))
  local _, end_row, end_col, _ = unpack(vim.fn.getpos("'>"))
  if start_row > end_row or (start_row == end_row and start_col > end_col) then
    start_row, end_row = end_row, start_row
    start_col, end_col = end_col, start_col
  end
  local lines = vim.fn.getline(start_row, end_row)
  local n = 0
  for _ in pairs(lines) do
    n = n + 1
  end
  if n <= 0 then
    return nil
  end
  lines[n] = string.sub(lines[n], 1, end_col)
  lines[1] = string.sub(lines[1], start_col)
  return table.concat(lines, "\n")
end

function M.get_git_directory()
  local Job = require("plenary.job")
  local s, ret = Job:new({
    command = "git",
    args = { "rev-parse", "--show-superproject-working-tree", "--show-toplevel" },
  }):sync()
  if ret == 0 then
    return s[1]
  else
    return vim.loop.cwd()
  end
end

function M.check_lsp_client_active(name)
  local clients = vim.lsp.get_active_clients()
  for _, client in pairs(clients) do
    if client.name == name then
      return true
    end
  end
  return false
end

local OS = vim.loop.os_uname().sysname

M.os = {
  name = OS,
  is_macos = OS == "Darwin",
  is_windows = OS:match("Windows"),
  is_linux = not (OS == "Darwin" and OS:match("Windows")),
}

M.icons = {
  web_dev_icons = {
    deb = { icon = "", name = "Deb" },
    lock = { icon = "󰌾", name = "Lock" },
    mp3 = { icon = "󰎆", name = "Mp3" },
    mp4 = { icon = "", name = "Mp4" },
    out = { icon = "", name = "Out" },
    ["robots.txt"] = { icon = "󰚩", name = "Robots" },
    ttf = { icon = "", name = "TrueTypeFont" },
    rpm = { icon = "", name = "Rpm" },
    woff = { icon = "", name = "WebOpenFontFormat" },
    woff2 = { icon = "", name = "WebOpenFontFormat2" },
    xz = { icon = "", name = "Xz" },
    zip = { icon = "", name = "Zip" },
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.INFO] = " ",
      [vim.diagnostic.severity.HINT] = " ",
    },
  },
  dap = {
    { name = "DapBreakpoint", text = "" },
    { name = "DapBreakpointCondition", text = "" },
    { name = "DapBreakpointRejected", text = "" },
    { name = "DapLogPoint", text = ".>" },
    { name = "DapStopped", text = "󰁕" },
  },
  diagnostics = {
    Error = " ", -- U+EA87
    Warn = " ", -- U+EA6C
    Hint = " ", -- U+EA6B
    Info = " ", -- U+EA74
    Ok = " ", -- U+EAB2
  },
  git = {
    added = " ", -- U+EADC
    modified = " ", -- U+EADE
    removed = " ", -- U+EADF
    staged = "",
    ahead = "⇡ ",
    behind = "⇣ ",
    diverged = "⇡⇣ ",
    up_to_date = "",
    untracked = " ",
    -- modified = "● ",
    deleted = " ",
    stashed = " ",
    renamed = "✎ ",
    conflicted = "ﲅ ",
    -- Status type
    ignored = "",
    conflict = "",
    unstaged = "󰄱",
  },
  cmp = {
    calc = "± ",
    emoji = "☺ ",
    latex_symbols = "λ ",
    Copilot = " ",
    Copilot_alt = " ",
    nvim_lsp = " ",
    nvim_lua = " ",
    path = " ",
    treesitter = " ",
    buffer = "﬘ ",
    zsh = " ",
    luasnip = " ",
    spell = "暈 ",
  },
  status = {
    line_number = " ",
    column_number = " ",
    folder = " ",
    root_folder = " ",
    git = " ",
    branch = " ",
    vimode = " ",
    lsp = " ",
    dap = " ",
    treesitter = " ",
  },
  kinds = {
    Array = "󰅪 ",
    Boolean = " ",
    BreakStatement = "󰙧 ",
    Call = "󰃷 ",
    CaseStatement = "󱃙 ",
    Class = " ",
    Color = " ",
    Constant = " ",
    Constructor = "",
    ContinueStatement = "→ ",
    Copilot = " ",
    Declaration = "󰙠 ",
    Delete = "󰩺 ",
    DoStatement = "󰕇 ",
    -- Enum = "了 ",
    Enum = " ",
    EnumMember = " ",
    -- EnumMember = " ",
    Event = " ",
    Field = " ",
    File = " ",
    Folder = " ",
    ForStatement = "󰑖 ",
    Function = "󰊕 ",
    Identifier = "󰀫 ",
    IfStatement = "󰇉 ",
    Interface = " ",
    Key = "󰌋 ",
    Keyword = " ",
    List = " ",
    Log = "󰦪 ",
    Lsp = " ",
    Macro = "󰁌 ",
    MarkdownH1 = "󰉫 ",
    MarkdownH2 = "󰉬 ",
    MarkdownH3 = "󰉭 ",
    MarkdownH4 = "󰉮 ",
    MarkdownH5 = "󰉯 ",
    MarkdownH6 = "󰉰 ",
    Method = " ",
    Module = " ",
    Namespace = " ",
    Null = "󰢤 ",
    Number = "#",
    Object = "󰀚 ",
    Operator = " ",
    Package = " ",
    Property = " ",
    Reference = " ",
    Regex = " ",
    Repeat = "󰑖 ",
    Scope = " ",
    Snippet = "󰩫 ",
    Specifier = "󰦪 ",
    Statement = " ",
    String = "󰉾 ",
    Struct = " ",
    SwitchStatement = "󰺟 ",
    Terminal = " ",
    Text = " ",
    Type = " ",
    TypeParameter = " ",
    Unit = " ",
    Value = " ",
    Variable = " ",
    WhileStatement = "󰑖 ",
  },
  document_symbols = {
    Array = { icon = "󰅪", hl = "Type" },
    Boolean = { icon = "⊨", hl = "TSBoolean" },
    Class = { icon = "󰌗", hl = "Include" },
    Constant = { icon = "", hl = "TSConstant" },
    Constructor = { icon = "", hl = "TSConstructor" },
    Enum = { icon = "󰒻", hl = "@number" },
    EnumMember = { icon = "", hl = "TSField" },
    Event = { icon = " ", hl = "TSType" },
    Field = { icon = " ", hl = "TSField" },
    File = { icon = "󰈙", hl = "Tag" },
    Function = { icon = "󰊕", hl = "Function" },
    Interface = { icon = " ", hl = "TSType" },
    Key = { icon = "󰌋", hl = "TSType" },
    Method = { icon = "ƒ", hl = "TSMethod" },
    Module = { icon = " ", hl = "TSNamespace" },
    Namespace = { icon = "󰌗", hl = "Include" },
    Null = { icon = "󰢤 ", hl = "TSType" },
    Number = { icon = "󰎠", hl = "Number" },
    Object = { icon = "󰅩", hl = "Type" },
    Operator = { icon = "󰆕", hl = "Operator" },
    Package = { icon = "󰏖", hl = "Label" },
    Property = { icon = "󰆧", hl = "@property" },
    StaticMethod = { icon = "󰠄 ", hl = "Function" },
    String = { icon = "󰀬", hl = "String" },
    Struct = { icon = "󰌗", hl = "Type" },
    TypeParameter = { icon = "󰊄", hl = "Type" },
    Variable = { icon = "", hl = "TSConstant" },
  },
  neo_tree = {
    ActiveLSP = "",
    ActiveTS = "",
    ArrowLeft = "",
    ArrowRight = "",
    Bookmarks = "",
    BufferClose = "󰅖",
    DapBreakpoint = "",
    DapBreakpointCondition = "",
    DapBreakpointRejected = "",
    DapLogPoint = ".>",
    DapStopped = "󰁕",
    Debugger = "",
    DefaultFile = "󰈙",
    Diagnostic = "󰒡",
    DiagnosticError = "",
    DiagnosticHint = "󰌵",
    DiagnosticInfo = "󰋼",
    DiagnosticWarn = "",
    Ellipsis = "…",
    FileNew = "",
    FileModified = "",
    FileReadOnly = "",
    FoldClosed = "",
    FoldOpened = "",
    FoldSeparator = " ",
    FolderClosed = "",
    FolderEmpty = "",
    FolderOpen = "",
    Git = "󰊢",
    GitAdd = "",
    GitBranch = "",
    GitChange = "",
    GitConflict = "",
    GitDelete = "",
    GitIgnored = "◌",
    GitRenamed = "➜",
    GitSign = "▎",
    GitStaged = "✓",
    GitUnstaged = "✗",
    GitUntracked = "★",
    LSPLoaded = "",
    LSPLoading1 = "",
    LSPLoading2 = "󰀚",
    LSPLoading3 = "",
    MacroRecording = "",
    Package = "󰏖",
    Paste = "󰅌",
    Refresh = "",
    Search = "",
    Selected = "❯",
    Session = "󱂬",
    Sort = "󰒺",
    Spellcheck = "󰓆",
    Tab = "󰓩",
    TabClose = "󰅙",
    Terminal = "",
    Window = "",
    WordFile = "󰈭",
  },
}

function M.strsplit(s, delimiter)
  local result = {}
  for match in (s .. delimiter):gmatch("(.-)" .. delimiter) do
    table.insert(result, match)
  end
  return result
end

M.root_patterns = { ".git", "lua" }

function M.get_root()
  ---@type string?
  local path = vim.api.nvim_buf_get_name(0)
  path = path ~= "" and vim.loop.fs_realpath(path) or nil
  ---@type string[]
  local roots = {}
  if path then
    for _, client in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
      local workspace = client.config.workspace_folders
      local paths = workspace and vim.tbl_map(function(ws)
        return vim.uri_to_fname(ws.uri)
      end, workspace) or client.config.root_dir and { client.config.root_dir } or {}
      for _, p in ipairs(paths) do
        local r = vim.loop.fs_realpath(p)
        if path:find(r, 1, true) then
          roots[#roots + 1] = r
        end
      end
    end
  end
  table.sort(roots, function(a, b)
    return #a > #b
  end)
  ---@type string?
  local root = roots[1]
  if not root then
    path = path and vim.fs.dirname(path) or vim.loop.cwd()
    ---@type string?
    root = vim.fs.find(M.root_patterns, { path = path, upward = true })[1]
    root = root and vim.fs.dirname(root) or vim.loop.cwd()
  end
  ---@cast root string
  return root
end

function M.warn(msg)
  vim.notify(msg, vim.log.levels.WARN)
end

function M.error(msg)
  vim.notify(msg, vim.log.levels.ERROR)
end

function M.info(msg)
  vim.notify(msg, vim.log.levels.INFO)
end

return M
