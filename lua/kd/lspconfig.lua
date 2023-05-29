require("neodev").setup({})

local styluaConfig = {
  extra_args = { "--config-path", vim.fn.expand("~/gitrepos/dotfiles/.stylua.toml") },
}
require("null-ls").setup({
  on_attach = require("lsp-format").on_attach,
  border = "single",
  sources = {
    require("null-ls").builtins.formatting.stylua.with(styluaConfig),
  },
})

local lspconfig = require("lspconfig")

lspconfig.lua_ls.setup({
  on_attach = function(client)
    -- Disable formatting with sumneko_lua. Use stylua in efm instead
    client.server_capabilities.documentFormattingProvider = false
  end,
  settings = {
    Lua = {
      completion = {
        callSnippet = "Replace",
      },
    },
  },
})
