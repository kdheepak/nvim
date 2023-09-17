return {
  {
    -- LSP Configuration & Plugins
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")
      lspconfig.lua_ls.setup({
        on_attach = function(client)
          -- Disable formatting with sumneko_lua. Use stylua instead
          client.server_capabilities.documentFormattingProvider = false
        end,
      })
    end,
    dependencies = {
      { "simrat39/rust-tools.nvim" },
      {
        "simrat39/symbols-outline.nvim",
        cmd = "SymbolsOutline",
        opts = {
          highlight_hovered_item = true,
          show_guides = true,
          auto_preview = false,
          position = "right",
          relative_width = true,
          width = 25,
          auto_close = false,
          show_numbers = false,
          show_relative_numbers = false,
          show_symbol_details = true,
          preview_bg_highlight = "Pmenu",
          autofold_depth = nil,
          auto_unfold_hover = true,
          fold_markers = { "", "" },
          keymaps = { -- These keymaps can be a string or a table for multiple keys
            close = { "<Esc>", "q" },
            goto_location = "<Cr>",
            focus_location = "o",
            hover_symbol = "<C-space>",
            toggle_preview = "K",
            rename_symbol = "r",
            code_actions = "a",
            fold = "h",
            unfold = "l",
            fold_all = "W",
            unfold_all = "E",
            fold_reset = "R",
          },
          lsp_blacklist = {},
          symbol_blacklist = {},
          symbols = require("kd.utils").icons.document_symbols,
        },
        keys = {
          { "<Leader>o", "<cmd>SymbolsOutline<CR>", desc = "Symbols Outline" },
        },
      },
      -- Automatically install LSPs to stdpath for neovim
      {
        "williamboman/mason.nvim",
        build = ":MasonUpdate", -- :MasonUpdate updates registry contents
        opts = {
          ui = {
            icons = {
              package_installed = "✓",
              package_pending = "➜",
              package_uninstalled = "✗",
            },
          },
        },
      },
      {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
          "lukas-reineke/lsp-format.nvim",
        },
        config = function()
          -- Diagnostic signs
          local diagnostic_signs = require("kd.utils").icons.diagnostic_signs
          for _, sign in ipairs(diagnostic_signs) do
            vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = sign.name })
          end

          local diagnostic = {
            virtual_text = false,
            underline = true,
            update_in_insert = false,
            severity_sort = true,
            float = {
              focusable = false,
              style = "minimal",
              border = "rounded",
            },
          }
          vim.diagnostic.config(diagnostic)

          -- Enable the following language servers
          local ensure_installed = {
            "clangd",
            "pyright",
            "julials",
            "jsonls",
            "rust_analyzer@nightly",
            "tsserver",
            "lua_ls",
          }

          -- Ensure the servers above are installed
          require("mason-lspconfig").setup({
            ensure_installed = ensure_installed,
          })

          --  This function gets run when an LSP connects to a particular buffer.
          local on_attach = function(client, bufnr)
            -- In this case, we create a function that lets us more easily define mappings specific
            -- for LSP related items. It sets the mode, buffer and description for us each time.
            require("lsp-format").on_attach(client)
            -- Create a command `:LSPFormat` local to the LSP buffer
            vim.api.nvim_buf_create_user_command(bufnr, "LSPFormat", function(_)
              vim.lsp.buf.format()
            end, { desc = "Format current buffer with LSP" })
          end

          local capabilities = vim.lsp.protocol.make_client_capabilities()
          capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

          local lspconfig = require("lspconfig")

          require("mason-lspconfig").setup_handlers({
            function(server_name)
              -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
              lspconfig[server_name].setup({
                capabilities = capabilities,
                on_attach = on_attach,
              })
            end,
            ["rust_analyzer"] = function()
              require("rust-tools").setup({
                tools = {
                  runnables = {
                    use_telescope = true,
                  },
                  hover_actions = {
                    auto_focus = false,
                  },
                  inlay_hints = {
                    only_current_line = true,
                  },
                },
                -- all the opts to send to nvim-lspconfig
                -- these override the defaults set by rust-tools.nvim
                -- see https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#rust_analyzer
                server = {
                  settings = {
                    ["rust-analyzer"] = {
                      cargo = {
                        allFeatures = true,
                      },
                      ["updates.channel"] = "nightly",
                      rustfmt = {
                        extraArgs = { "+nightly" },
                      },
                    },
                  },
                },
              })
            end,
            ["lua_ls"] = function()
              local opts = require("kd.plugins.lsp.config.lua_ls")
              opts["capabilities"] = capabilities
              opts["on_attach"] = on_attach
              lspconfig.lua_ls.setup(opts)
            end,
            ["jsonls"] = function()
              local opts = require("kd.plugins.lsp.config.jsonls")
              opts["capabilities"] = capabilities
              opts["on_attach"] = on_attach
              lspconfig.jsonls.setup(opts)
            end,
          })
        end,
      },

      -- { "j-hui/fidget.nvim", opts = {} },

      -- init.lua and plugin development with full signature help, docs and completion for the nvim lua API.
      { "folke/neodev.nvim", opts = {} },

      -- project local configuration
      { "folke/neoconf.nvim", cmd = "Neoconf" },

      {
        "elentok/format-on-save.nvim",
        config = function()
          local format_on_save = require("format-on-save")
          local formatters = require("format-on-save.formatters")

          format_on_save.setup({
            formatter_by_ft = {
              css = formatters.lsp,
              html = formatters.lsp,
              java = formatters.lsp,
              javascript = formatters.lsp,
              json = formatters.prettierd,
              -- toml = formatters.prettierd,
              lua = formatters.stylua,
              markdown = formatters.prettierd,
              python = formatters.black,
              rust = formatters.lsp,
              sh = formatters.shfmt,
              scss = formatters.lsp,
              typescript = formatters.prettierd,
              typescriptreact = formatters.prettierd,
              yaml = formatters.lsp,
            },
            -- Optional: fallback formatter to use when no formatters match the current filetype
            fallback_formatter = {
              formatters.remove_trailing_whitespace,
              -- formatters.remove_trailing_newlines,
              -- formatters.prettierd,
            },
          })
        end,
      },
    },
  },
}
