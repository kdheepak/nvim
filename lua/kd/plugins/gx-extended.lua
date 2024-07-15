return {
  "rmagatti/gx-extended.nvim",
  config = function()
    require("gx-extended").setup({
      open_fn = require("lazy.util").open,
      extensions = {
        { -- match github repos in lazy.nvim plugin specs
          patterns = { "*" },
          name = "github",
          match_to_url = function(line_string)
            local line = string.match(line_string, "[\"'].-/.-[\"']")
            local repo = vim.split(line, ":")[1]:gsub("[\"']", "")
            local url = "https://github.com/" .. repo
            return line and repo and url or nil
          end,
        },
        {
          patterns = { "*" },
          name = "google",
          match_to_url = function()
            local word = vim.fn.expand("<cword>")
            local url = "https://www.google.com/search?q=" .. word
            return url or nil
          end,
        },
      },
    })
  end,
}
