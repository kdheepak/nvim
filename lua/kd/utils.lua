local M = {}

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

return M
