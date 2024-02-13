local fzf_lua = require("fzf-lua")
local fzf_helpers = require("fzf.helpers")
local core = require("fzf-lua.core")
local path = require("fzf-lua.path")
local config = require("fzf-lua.config")
local actions = require("fzf-lua.actions")

local function should_qf(selected)
  if #selected <= 2 then
    return false
  end

  for _, sel in ipairs(selected) do
    if string.match(sel, "^.+:%d+:%d+:") then
      return true
    end
  end

  return false
end

local function edit_or_qf(selected, opts)
  if should_qf(selected) then
    actions.file_sel_to_qf(selected)
    vim.cmd("cc")
  else
    actions.file_edit(selected, opts)
  end
end

require("fzf-lua").setup({
  fzf_layout = "reverse", -- fzf '--layout='
  previewers = {
    bat = {
      config = vim.fn.expand("~/.config/bat/config"),
    },
    builtin = {
      extensions = {
        ["png"] = { "catimg", "-w", "80" },
        ["jpeg"] = { "catimg", "-w", "80" },
        ["jpg"] = { "catimg", "-w", "80" },
      },
    },
  },
  files = {
    actions = {
      ["default"] = edit_or_qf,
    },
  },
  git = {
    files = {
      actions = {
        ["default"] = edit_or_qf,
      },
    },
  },
  grep = {
    rg_opts = "--hidden --column --line-number --sort-files --no-heading --color=always --smart-case -g '!{.git,node_modules}/*'",
    actions = {
      ["default"] = edit_or_qf,
    },
  },
  buffers = {
    actions = {
      ["default"] = edit_or_qf,
    },
  },
  blines = {
    actions = {
      ["default"] = edit_or_qf,
    },
  },
  lsp = {
    actions = {
      ["default"] = edit_or_qf,
    },
  },
})

fzf_lua.register_ui_select()
