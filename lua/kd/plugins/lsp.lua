return {
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      {
        'williamboman/mason.nvim',
        cmd = "Mason",
        keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
        opts = {
          ensure_installed = {
            "stylua",
            "shfmt",
            "flake8",
          },
        },
        config = function(_, opts)
          require("mason").setup(opts)
          local mr = require("mason-registry")
          local function ensure_installed()
            for _, tool in ipairs(opts.ensure_installed) do
              local p = mr.get_package(tool)
              if not p:is_installed() then
                p:install()
              end
            end
          end
          if mr.refresh then
            mr.refresh(ensure_installed)
          else
            ensure_installed()
          end
        end,
      },
      {
        'williamboman/mason-lspconfig.nvim',
        config = function()
          -- [[ Configure LSP ]]
          --  This function gets run when an LSP connects to a particular buffer.
          local on_attach = function(_, bufnr)
            -- NOTE: Remember that lua is a real programming language, and as such it is possible
            -- to define small helper and utility functions so you don't have to repeat yourself
            -- many times.
            --
            -- In this case, we create a function that lets us more easily define mappings specific
            -- for LSP related items. It sets the mode, buffer and description for us each time.
            local nmap = function(keys, func, desc)
              if desc then
                desc = 'LSP: ' .. desc
              end

              vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
            end

            nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
            nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

            nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
            -- nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
            nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
            nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
            -- nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
            -- nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

            -- See `:help K` for why this keymap
            nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
            nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

            -- Lesser used LSP functionality
            nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
            nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
            nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
            nmap('<leader>wl', function()
              print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            end, '[W]orkspace [L]ist Folders')

            -- Create a command `:Format` local to the LSP buffer
            vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
              vim.lsp.buf.format()
            end, { desc = 'Format current buffer with LSP' })
          end

          -- Enable the following language servers
          --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
          --
          --  Add any additional override configuration in the following tables. They will be passed to
          --  the `settings` field of the server config. You must look up that documentation yourself.
          local servers = {
            -- clangd = {},
            -- gopls = {},
            -- pyright = {},
            -- rust_analyzer = {},
            -- tsserver = {},

            lua_ls = {
              Lua = {
                workspace = { checkThirdParty = false },
                telemetry = { enable = false },
              },
            },
          }

          -- Ensure the servers above are installed
          local mason_lspconfig = require 'mason-lspconfig'

          mason_lspconfig.setup {
            ensure_installed = vim.tbl_keys(servers),
          }

          mason_lspconfig.setup_handlers {
            function(server_name)
              -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
              local capabilities = vim.lsp.protocol.make_client_capabilities()
              capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
              require('lspconfig')[server_name].setup {
                capabilities = capabilities,
                on_attach = on_attach,
                settings = servers[server_name],
              }
            end,
          }
        end
      },

      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim',  opts = {} },

      -- project local configuration
      { "folke/neoconf.nvim", cmd = "Neoconf" },
    },
  },
  -- formatters
  {
    "jay-babu/mason-null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "jose-elias-alvarez/null-ls.nvim",
      "nvim-lua/plenary.nvim",
      "lukas-reineke/lsp-format.nvim",
    },
    config = function()
      require("mason").setup()
      require("mason-null-ls").setup({
        automatic_setup = true,
        ensure_installed = { "stylua", "jq",
          "isort",
          "black",
          "eslint_lsp",
          "prettierd"

        }
      })
      require("null-ls").setup {
        on_attach = require("lsp-format").on_attach,
        border = "single"
      }
      require("lspconfig").lua_ls.setup { on_attach = require("lsp-format").on_attach }
    end,
  },
}
