return {
  "haya14busa/vim-asterisk",
  config = function()
    vim.g["asterisk#keeppos"] = 1
    local map = require("kd.utils").map
    map("", "*", "<Plug>(asterisk-z*)")
    map("", "#", "<Plug>(asterisk-z#)")
    map("", "g*", "<Plug>(asterisk-gz*)")
    map("", "g#", "<Plug>(asterisk-gz#)")
  end,
}
