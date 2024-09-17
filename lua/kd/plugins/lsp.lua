return {
  { "rhaiscript/vim-rhai" },
  {
    "folke/lazydev.nvim",
    ft = "lua",
    dependencies = {
      { "justinsgithub/wezterm-types", lazy = true },
      { "Bilal2453/luvit-meta", lazy = true },
    },
    opts = {
      library = {
        "lazy.nvim",
        { path = "luvit-meta/library", words = { "vim%.uv" } },
        { path = "wezterm-types", mods = { "wezterm" } },
      },
    },
  },
  {
    -- LSP Configuration & Plugins
    "neovim/nvim-lspconfig",
    dependencies = {
      { "simrat39/rust-tools.nvim" },
      {
        "hedyhli/outline.nvim",
        cmd = "Outline",
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
          { "<Leader>lo", "<cmd>Outline<CR>", desc = "LSP Symbols Outline" },
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
                exclude = { "lua_ls" }, -- to let only stylua
              },
            })
          end,
        },
        config = function()
          local border = {
            { "╭", "FloatBorder" },
            { "─", "FloatBorder" },
            { "╮", "FloatBorder" },
            { "│", "FloatBorder" },
            { "╯", "FloatBorder" },
            { "─", "FloatBorder" },
            { "╰", "FloatBorder" },
            { "│", "FloatBorder" },
          }
          local handlers = {
            ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = border }),
            ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = border }),
          }

          local diagnostic = {
            virtual_text = false,
            underline = true,
            update_in_insert = false,
            signs = require("kd.utils").icons.signs,
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
            -- "bashls",
            "clangd",
            "cmake",
            "jsonls",
            "lua_ls",
            "marksman",
            "pyright",
            "rust_analyzer@nightly",
            "tsserver",
            -- "fennel_ls",
            -- "actionlint",
            -- "black",
            -- "commitlint",
            -- "cspell",
            -- "eslint-lsp",
            -- "isort",
            -- "jq",
            -- "json-lsp",
            -- "julials",
            -- "markdownlint",
            -- "prettier",
            -- "prettierd",
            -- "proselint",
            -- "shellcheck",
            -- "shfmt",
            -- "stylua",
            -- "svelte-language-server",
            -- "tailwindcss-language-server",
            -- "tree-sitter-cli",
            -- "yamlfmt",
          }

          -- Ensure the servers above are installed
          require("mason-lspconfig").setup({
            ensure_installed = ensure_installed,
          })

          local capabilities = vim.lsp.protocol.make_client_capabilities()
          capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
          capabilities.textDocument.completion.completionItem.snippetSupport = false

          local lspconfig = require("lspconfig")

          local function on_attach(client, bufnr)
            require("lsp-format").on_attach(client, bufnr)
          end

          require("mason-lspconfig").setup_handlers({
            function(server_name)
              -- TODO: temporary hack till mason-lspconfig handles ts_ls
              if server_name == "tsserver" then
                server_name = "ts_ls"
              end
              -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
              lspconfig[server_name].setup({
                capabilities = capabilities,
                on_attach = on_attach,
                handlers = handlers,
              })
            end,
            ["fennel_ls"] = function()
              lspconfig.fennel_ls.setup({
                init_options = { ["fennel-ls"] = { ["extra-globals"] = "vim" } },
              })
            end,
            ["rust_analyzer"] = function()
              lspconfig.rust_analyzer.setup({
                capabilities = capabilities,
                on_attach = on_attach,
                settings = {
                  ["rust-analyzer"] = {
                    checkOnSave = {
                      command = "clippy",
                    },
                    ["updates.channel"] = "nightly",
                    rustfmt = {
                      extraArgs = { "+nightly" },
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
              if resource_path then
                table.insert(lua_library_files, resource_path .. "/lua-types")
              end
              table.insert(lua_library_files, vim.fn.expand("$VIMRUNTIME/lua"))

              local runtime_path = vim.split(package.path, ";")
              table.insert(runtime_path, "lua/?.lua")
              table.insert(runtime_path, "lua/?/init.lua")
              table.insert(runtime_path, "?.lua")
              table.insert(runtime_path, "?/init.lua")
              if resource_path then
                table.insert(runtime_path, resource_path .. "/lua-plugin/plugin.lua")
              end

              local opts = {
                settings = {
                  tinymist = {
                    settings = {
                      exportPdf = "onType",
                      outputPath = "$root/target/$dir/$name",
                    },
                  },
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
              opts["handlers"] = handlers
              lspconfig.lua_ls.setup(opts)
            end,
            ["jsonls"] = function()
              local opts = {}
              opts["capabilities"] = capabilities
              opts["on_attach"] = on_attach
              opts["handlers"] = handlers
              lspconfig.jsonls.setup(opts)
            end,
          })
        end,
      },
      {
        "robitx/gp.nvim",
        config = function()
          require("gp").setup({
            chat_conceal_model_params = false,
          })
        end,
      },
      {
        "stevearc/conform.nvim",
        opts = {},
        config = function()
          require("conform").setup({
            formatters_by_ft = {
              lua = { "stylua" },
              -- Conform will run multiple formatters sequentially
              fennel = { "fnlfmt" },
              typst = { "typstyle" },
              -- Use a sub-list to run only the first available formatter
              javascript = { "prettierd" },
              -- markdown = { "prettierd" },
              sh = { "shfmt" },
              json = { "jq" },
            },
            -- If this is set, Conform will run the formatter on save.
            -- It will pass the table to conform.format().
            -- This can also be a function that returns the table.
            format_on_save = {
              -- I recommend these options. See :help conform.format for details.
              lsp_fallback = true,
              timeout_ms = 500,
            },
            -- If this is set, Conform will run the formatter asynchronously after save.
            -- It will pass the table to conform.format().
            -- This can also be a function that returns the table.
            format_after_save = {
              lsp_fallback = true,
            },
          })
          require("conform").formatters.shfmt =
            { prepend_args = { "--indent", "4", "--case-indent", "--space-redirects", "--simplify" } }
        end,
      },

      {
        "j-hui/fidget.nvim",
        event = "BufEnter",
        config = function()
          require("fidget").setup()
        end,
        tag = "legacy",
        dependencies = { "neovim/nvim-lspconfig" },
      },

      -- project local configuration
      { "folke/neoconf.nvim", cmd = "Neoconf" },
    },
  },
}
