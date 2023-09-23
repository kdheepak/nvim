return {
  {
    -- LSP Configuration & Plugins
    "neovim/nvim-lspconfig",
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
          config = function()
            require("lsp-format").setup({
              lua = {
                exclude = { "lua_ls" }, -- to let only null_ls with stylua to format
              },
            })
          end,
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
            "jsonls",
            "rust_analyzer@nightly",
            "tsserver",
            "lua_ls",
          }

          -- Ensure the servers above are installed
          require("mason-lspconfig").setup({
            ensure_installed = ensure_installed,
          })

          local capabilities = vim.lsp.protocol.make_client_capabilities()
          capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

          local lspconfig = require("lspconfig")

          local function on_attach(client, bufnr)
            require("lsp-format").on_attach(client, bufnr)
          end

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
              local function get_quarto_resource_path()
                local f = assert(io.popen("quarto --paths", "r"))
                local s = assert(f:read("*a"))
                f:close()
                return require("kd.utils").strsplit(s, "\n")[2]
              end

              local resource_path = get_quarto_resource_path()

              local lua_library_files = vim.api.nvim_get_runtime_file("", true)
              table.insert(lua_library_files, resource_path .. "/lua-types")
              table.insert(lua_library_files, vim.fn.expand("$VIMRUNTIME/lua"))

              local runtime_path = vim.split(package.path, ";")
              table.insert(runtime_path, "lua/?.lua")
              table.insert(runtime_path, "lua/?/init.lua")
              table.insert(runtime_path, "?.lua")
              table.insert(runtime_path, "?/init.lua")
              table.insert(runtime_path, resource_path .. "/lua-plugin/plugin.lua")

              local opts = {
                settings = {
                  Lua = {
                    runtime = {
                      special = {
                        req = "require",
                      },
                      version = "LuaJIT",
                      path = runtime_path,
                    },
                    diagnostics = {
                      globals = {
                        "vim",
                        "require",
                        "rocks",
                      },
                    },
                    workspace = {
                      -- Make the server aware of Neovim runtime files
                      library = lua_library_files,
                      ignoreDir = "tmp/",
                      useGitIgnore = false,
                      maxPreload = 100000000,
                      preloadFileSize = 500000,
                      checkThirdParty = false,
                    },
                    -- Do not send telemetry data containing a randomized but unique identifier
                    telemetry = {
                      enable = false,
                    },
                  },
                },

                server_capabilities = {
                  definition = true,
                  typeDefinition = true,
                },
              }
              opts["capabilities"] = capabilities
              opts["on_attach"] = on_attach
              -- lspconfig.lua_ls.setup(opts)
            end,
            ["jsonls"] = function()
              local opts = {}
              opts["capabilities"] = capabilities
              opts["on_attach"] = on_attach
              lspconfig.jsonls.setup(opts)
            end,
          })
        end,
      },

      -----------------------------------------------------------------------------
      {
        "mhartington/formatter.nvim",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
        opts = function(_, opts)
          opts = opts or {}
          local defaults = {
            logging = true,
            log_level = vim.log.levels.WARN,
            filetype = {
              lua = { require("formatter.filetypes.lua").stylua },
            },
          }
          opts = vim.tbl_extend("keep", opts, defaults)
          return opts
        end,
        config = function(opts)
          require("formatter").setup(opts)
          vim.api.nvim_create_autocmd("BufWritePost", {
            pattern = {
              "*.js",
              "*.mjs",
              "*.cjs",
              "*.jsx",
              "*.ts",
              "*.tsx",
              "*.css",
              "*.scss",
              "*.md",
              "*.html",
              "*.lua",
              "*.json",
              "*.jsonc",
              "*.vue",
              "*.py",
              "*.gql",
              "*.graphql",
              "*.go",
              "*.rs",
              "*.astro",
            },
            command = "FormatWrite",
          })
        end,
      },

      -- { "j-hui/fidget.nvim", opts = {} },

      -- init.lua and plugin development with full signature help, docs and completion for the nvim lua API.
      { "folke/neodev.nvim", opts = {} },

      -- project local configuration
      { "folke/neoconf.nvim", cmd = "Neoconf" },
    },
  },
}
