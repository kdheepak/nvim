return {
  {
    -- LSP Configuration & Plugins
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")
      lspconfig.lua_ls.setup({
        on_attach = function(client)
          -- Disable formatting with sumneko_lua. Use stylua in null-ls instead
          client.server_capabilities.documentFormattingProvider = false
        end,
      })
    end,
    dependencies = {
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
          symbols = require("kd/utils").icons.document_symbols,
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
          local diagnostic_signs = require("kd/utils").icons.diagnostic_signs
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

          local function get_quarto_resource_path()
            local f = assert(io.popen("quarto --paths", "r"))
            local s = assert(f:read("*a"))
            f:close()
            return require("kd/utils").strsplit(s, "\n")[2]
          end

          local lua_library_files = vim.api.nvim_get_runtime_file("", true)
          local resource_path = get_quarto_resource_path()
          table.insert(lua_library_files, resource_path .. "/lua-types")
          table.insert(lua_library_files, vim.fn.expand("$VIMRUNTIME/lua"))
          local lua_plugin_paths = {}
          table.insert(lua_plugin_paths, resource_path .. "/lua-plugin/plugin.lua")

          -- Enable the following language servers
          local servers = {
            clangd = {},
            pyright = {},
            julials = {},
            rust_analyzer = {},
            tsserver = {},
            lua_ls = {
              Lua = {
                completion = {
                  callSnippet = "Replace",
                },
                runtime = {
                  version = "LuaJIT",
                  plugin = lua_plugin_paths,
                },
                diagnostics = {
                  globals = { "vim", "quarto", "pandoc", "io", "string", "print", "require", "table" },
                },
                workspace = {
                  checkThirdParty = false,
                  library = lua_library_files,
                },
                telemetry = { enable = false },
              },
            },
          }

          -- Ensure the servers above are installed
          local mason_lspconfig = require("mason-lspconfig")

          mason_lspconfig.setup({
            ensure_installed = vim.tbl_keys(servers),
          })

          mason_lspconfig.setup_handlers({
            function(server_name)
              -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
              local capabilities = vim.lsp.protocol.make_client_capabilities()
              capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
              require("lspconfig")[server_name].setup({
                capabilities = capabilities,
                on_attach = on_attach,
                settings = servers[server_name],
              })
            end,
          })
        end,
      },

      -- { "j-hui/fidget.nvim", opts = {} },

      -- init.lua and plugin development with full signature help, docs and completion for the nvim lua API.
      { "folke/neodev.nvim", opts = {} },

      -- project local configuration
      { "folke/neoconf.nvim", cmd = "Neoconf" },

      -- null-ls
      {
        "jay-babu/mason-null-ls.nvim",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
          "williamboman/mason.nvim",
          "jose-elias-alvarez/null-ls.nvim",
          "nvim-lua/plenary.nvim",
          "lukas-reineke/lsp-format.nvim",
          "davidmh/cspell.nvim",
        },
        config = function()
          require("mason").setup()
          require("mason-null-ls").setup({
            automatic_setup = true,
            ensure_installed = {
              "stylua",
              "jq",
              "isort",
              "black",
              "eslint_lsp",
              "prettierd",
              "proselint",
              "cspell",
              "shellcheck",
              "actionlint",
              "alex",
              "hadolint",
            },
          })
          local styluaConfig = {
            extra_args = { "--config-path", vim.fn.expand("~/gitrepos/dotfiles/.stylua.toml") },
          }
          local null_ls = require("null-ls")

          local on_attach = function(client, bufnr)
            require("lsp-format").on_attach(client)
            -- Create a command `:LSPFormat` local to the LSP buffer
            vim.api.nvim_buf_create_user_command(bufnr, "LSPFormat", function(_)
              vim.lsp.buf.format()
            end, { desc = "Format current buffer with LSP" })
          end

          null_ls.setup({
            on_attach = on_attach,
            sources = {
              null_ls.builtins.formatting.stylua.with(styluaConfig),
              null_ls.builtins.code_actions.eslint,
              null_ls.builtins.code_actions.eslint_d,
              -- null_ls.builtins.code_actions.gitsigns,
              null_ls.builtins.code_actions.proselint,
              null_ls.builtins.code_actions.shellcheck,
              null_ls.builtins.diagnostics.actionlint,
              null_ls.builtins.diagnostics.alex,
              null_ls.builtins.diagnostics.hadolint,
              null_ls.builtins.formatting.just,
              null_ls.builtins.formatting.prettierd.with({
                filetypes = {
                  "javascript",
                  "typescript",
                  "css",
                  "scss",
                  "html",
                  "json",
                  "yaml",
                  "markdown",
                  "graphql",
                  "md",
                  "txt",
                },
              }),
              null_ls.builtins.hover.dictionary,
              null_ls.builtins.hover.printenv,
            },
          })
        end,
      },
    },
  },
}
