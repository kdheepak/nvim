return {
  "Pocco81/HighStr.nvim",
  config = function()
    local vnoremap = require("kd.utils").vnoremap
    local nnoremap = require("kd.utils").nnoremap
    vnoremap("<leader>h1", ":<c-u>HSHighlight 1<CR>", { desc = "Highlight 1" })
    vnoremap("<leader>h2", ":<c-u>HSHighlight 2<CR>", { desc = "Highlight 2" })
    vnoremap("<leader>h3", ":<c-u>HSHighlight 3<CR>", { desc = "Highlight 3" })
    vnoremap("<leader>h4", ":<c-u>HSHighlight 4<CR>", { desc = "Highlight 4" })
    vnoremap("<leader>h5", ":<c-u>HSHighlight 5<CR>", { desc = "Highlight 5" })
    vnoremap("<leader>h6", ":<c-u>HSHighlight 6<CR>", { desc = "Highlight 6" })
    vnoremap("<leader>h7", ":<c-u>HSHighlight 7<CR>", { desc = "Highlight 7" })
    vnoremap("<leader>h8", ":<c-u>HSHighlight 8<CR>", { desc = "Highlight 8" })
    vnoremap("<leader>h9", ":<c-u>HSHighlight 9<CR>", { desc = "Highlight 9" })
    vnoremap("<leader>h0", ":<c-u>HSRmHighlight<CR>", { desc = "Highlight Remove" })
    vnoremap("<leader>hh", ":<c-u>HSRmHighlight rm_all<CR>", { desc = "Highlight Remove all" })
    nnoremap("<leader>hh", ":<c-u>HSRmHighlight rm_all<CR>", { desc = "Highlight Remove all" })
  end,
  event = "VeryLazy",
}
