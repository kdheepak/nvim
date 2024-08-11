local function feedkeys(key, mode)
  return vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

local function slime_send_region()
  feedkeys(":<C-u>call slime#send_op(visualmode(), 1)<CR>", "n")
end

return {
  "jpalardy/vim-slime",
  config = function() end,
}
