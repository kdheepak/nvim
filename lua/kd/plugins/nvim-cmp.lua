return {
  "hrsh7th/nvim-cmp",
  lazy = false,
  version = false, -- last release is way too old
  dependencies = {
    -- Snippet Engine & its associated nvim-cmp source
    "hrsh7th/cmp-nvim-lsp",
    {
      "L3MON4D3/LuaSnip",
      build = (function()
        -- Build Step is needed for regex support in snippets
        -- This step is not supported in many windows environments
        -- Remove the below condition to re-enable on windows
        if vim.fn.has("win32") == 1 then
          return
        end
        return "make install_jsregexp"
      end)(),
    },
    "saadparwaiz1/cmp_luasnip",
    -- Adds LSP completion capabilities
    -- Adds a number of user-friendly snippets
    "rafamadriz/friendly-snippets",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-nvim-lsp-signature-help",
    "hrsh7th/cmp-cmdline",
    "nvim-lua/plenary.nvim",
    "petertriho/cmp-git",
    "nvim-tree/nvim-web-devicons",
    "ryo33/nvim-cmp-rust",
    "lukas-reineke/cmp-under-comparator",
    {
      "zjp-CN/nvim-cmp-lsp-rs",
      opts = {
        -- Filter out import items starting with one of these prefixes.
        -- A prefix can be crate name, module name or anything an import
        -- path starts with, no matter it's complete or incomplete.
        -- Only literals are recognized: no regex matching.
        unwanted_prefix = { "color", "ratatui::style::Styled" },
        -- make these kinds prior to others
        -- e.g. make Module kind first, and then Function second,
        --      the rest ordering is merged from a default kind list
        kind = function(k)
          -- The argument in callback is type-aware with opts annotated,
          -- so you can type the CompletionKind easily.
          return { k.Module, k.Function }
        end,
        -- Override the default comparator list provided by this plugin.
        -- Mainly used with key binding to switch between these Comparators.
        combo = {
          -- The key is the name for combination of comparators and used
          -- in notification in swiching.
          -- The value is a list of comparators functions or a function
          -- to generate the list.
          alphabetic_label_but_underscore_last = function()
            local comparators = require("cmp_lsp_rs").comparators
            return { comparators.sort_by_label_but_underscore_last }
          end,
          recentlyUsed_sortText = function()
            local compare = require("cmp").config.compare
            local comparators = require("cmp_lsp_rs").comparators
            -- Mix cmp sorting function with cmp_lsp_rs.
            return {
              compare.recently_used,
              compare.sort_text,
              comparators.sort_by_label_but_underscore_last,
            }
          end,
        },
      },
    },
  },
  opts = function(_, opts)
    local cmp = require("cmp")

    -- Set configuration for specific filetype.
    cmp.setup.filetype("gitcommit", {
      sources = cmp.config.sources({
        { name = "git" }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
      }, {
        { name = "buffer" },
      }),
    })

    -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline({ "/", "?" }, {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = "buffer" },
      },
    })

    -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline(":", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = "path" },
      }, {
        { name = "cmdline" },
      }),
    })

    -- See `:help cmp`
    local luasnip = require("luasnip")
    require("luasnip.loaders.from_vscode").lazy_load()
    luasnip.config.setup({})

    vim.api.nvim_create_autocmd("ModeChanged", {
      pattern = "*",
      callback = function()
        if
          ((vim.v.event.old_mode == "s" and vim.v.event.new_mode == "n") or vim.v.event.old_mode == "i")
          and require("luasnip").session.current_nodes[vim.api.nvim_get_current_buf()]
          and not require("luasnip").session.jump_active
        then
          require("luasnip").unlink_current()
        end
      end,
    })

    luasnip.config.set_config({
      region_check_events = "InsertEnter",
      delete_check_events = "TextChanged,InsertLeave",
    })

    local cmp_lsp_rs = require("cmp_lsp_rs")
    local comparators = cmp_lsp_rs.comparators
    local compare = require("cmp").config.compare

    return {
      sorting = {
        priority_weight = 2,
        comparators = {
          -- Give Copilot priority and then use the default comparators
          require("copilot_cmp.comparators").prioritize,

          cmp.config.compare.offset,
          cmp.config.compare.exact,
          -- cmp.config.compare.scopes,
          cmp.config.compare.score,
          cmp.config.compare.recently_used,
          cmp.config.compare.locality,
          cmp.config.compare.kind,
          -- cmp.config.compare.sort_text,
          cmp.config.compare.length,
          cmp.config.compare.order,
        },
      },
      preselect = cmp.PreselectMode.None,
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-x>"] = cmp.mapping.abort(),
        ["<C-e>"] = cmp.mapping.close(),
        ["<CR>"] = cmp.mapping({
          i = function(fallback)
            if cmp.visible() and cmp.get_active_entry() then
              cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
            else
              fallback()
            end
          end,
          s = cmp.mapping.confirm({ select = false }),
        }),
        ["<Tab>"] = vim.schedule_wrap(function(fallback)
          if cmp.visible() and require("kd.utils").has_words_before() then
            cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
          else
            fallback()
          end
        end),

        -- ["<Tab>"] = cmp.mapping(function(fallback)
        --   if cmp.visible() then
        --     cmp.select_next_item()
        --   elseif luasnip.expand_or_locally_jumpable() then
        --     luasnip.expand_or_jump()
        --   elseif require("kd.utils").has_words_before() then
        --     cmp.complete()
        --   else
        --     fallback()
        --   end
        -- end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      }),
      sources = cmp.config.sources({
        { name = "buffer", group_index = 2 },
        { name = "copilot", group_index = 2 },
        { name = "luasnip", group_index = 2 },
        { name = "nvim_lsp", group_index = 2 },
        { name = "nvim_lsp_signature_help", group_index = 2 },
        { name = "path", group_index = 2 },
        { name = "treesitter", group_index = 2 },
        { name = "git", group_index = 2 },
        { name = "vsnip", group_index = 2 },
      }),
      formatting = {
        format = function(entry, item)
          local icons = require("kd.utils").icons.kinds
          local cmp_icons = require("kd.utils").icons.cmp
          if icons[item.kind] then
            item.kind = icons[item.kind] .. item.kind
          end
          item.menu = cmp_icons[entry.source.name]
          return item
        end,
      },
    }
  end,
}
