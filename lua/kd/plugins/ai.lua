return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    config = function()
      require("copilot").setup({})
    end,
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    config = function(_, opts)
      local chat = require("CopilotChat")
      chat.setup(opts)
    end,
    build = "make tiktoken",
    branch = "main",
    keys = {
      { "<c-s>", "<CR>", ft = "copilot-chat", desc = "Submit Prompt", remap = true },
      { "<leader>a", "", desc = "+ai", mode = { "n", "v" } },
      {
        "<leader>aa",
        function()
          return require("CopilotChat").toggle()
        end,
        desc = "CopilotChat - Toggle",
        mode = { "n", "v" },
      },
      {
        "<leader>ax",
        function()
          return require("CopilotChat").reset()
        end,
        desc = "CopilotChat - clear",
        mode = { "n", "v" },
      },
      {
        "<leader>aq",
        function()
          local input = vim.fn.input("Quick Chat: ")
          if input ~= "" then
            require("CopilotChat").ask(input)
          end
        end,
        desc = "CopilotChat - Quick Chat",
        mode = { "n", "v" },
      },
      -- Show prompts actions with telescope
      {
        "<leader>ap",
        function()
          local actions = require("CopilotChat.actions")
          require("CopilotChat.integrations.fzflua").pick(actions.prompt_actions())
        end,
        desc = "CopilotChat - Prompt actions",
      },
      -- Show help actions with fzf-lua
      {
        "<leader>ah",
        function()
          local actions = require("CopilotChat.actions")
          require("CopilotChat.integrations.fzflua").pick(actions.help_actions())
        end,
        desc = "CopilotChat - Help actions",
      },
      -- Code related commands
      { "<leader>ae", "<cmd>CopilotChatExplain<cr>", desc = "CopilotChat - Explain code" },
      { "<leader>at", "<cmd>CopilotChatTests<cr>", desc = "CopilotChat - Generate tests" },
      { "<leader>ar", "<cmd>CopilotChatReview<cr>", desc = "CopilotChat - Review code" },
      { "<leader>aR", "<cmd>CopilotChatRefactor<cr>", desc = "CopilotChat - Refactor code" },
      { "<leader>an", "<cmd>CopilotChatBetterNamings<cr>", desc = "CopilotChat - Better Naming" },
      -- Chat with Copilot in visual mode
      {
        "<leader>av",
        ":CopilotChatVisual<cr>",
        mode = "x",
        desc = "CopilotChat - Open in vertical split",
      },
      {
        "<leader>aI",
        "<cmd>CopilotChatInline<cr>",
        desc = "CopilotChat - Inline chat",
      },
      -- Custom input for CopilotChat
      {
        "<leader>ai",
        function()
          local input = vim.fn.input("Ask Copilot: ")
          if input ~= "" then
            vim.cmd("CopilotChat " .. input)
          end
        end,
        desc = "CopilotChat - Ask input",
      },
      -- Generate commit message based on the git diff
      {
        "<leader>am",
        "<cmd>CopilotChatCommit<cr>",
        desc = "CopilotChat - Generate commit message for staged changes",
      },
      -- Quick chat with Copilot
      {
        "<leader>aq",
        function()
          local input = vim.fn.input("Quick Chat: ")
          if input ~= "" then
            vim.cmd("CopilotChatBuffer " .. input)
          end
        end,
        desc = "CopilotChat - Quick chat",
      },
      -- Debug
      { "<leader>ad", "<cmd>CopilotChatDebugInfo<cr>", desc = "CopilotChat - Debug Info" },
      -- Fix the issue with diagnostic
      { "<leader>af", "<cmd>CopilotChatFix<cr>", desc = "CopilotChat - Fix Diagnostic" },
      -- Clear buffer and chat history
      { "<leader>al", "<cmd>CopilotChatReset<cr>", desc = "CopilotChat - Clear buffer and chat history" },
      -- Toggle Copilot Chat Vsplit
      { "<leader>av", "<cmd>CopilotChatToggle<cr>", desc = "CopilotChat - Toggle" },
      -- Copilot Chat Models
      { "<leader>a?", "<cmd>CopilotChatModels<cr>", desc = "CopilotChat - Select Models" },
    },
  },
  -- {
  --   "yetone/avante.nvim",
  --   cmd = "AvanteAsk",
  --   build = "make",
  --   config = function()
  --     require("avante").setup({
  --       provider = "copilot",
  --       vendors = {
  --         claude_sonnet = {
  --           __inherited_from = "openai",
  --           api_key_name = "OPENROUTER_API_KEY",
  --           endpoint = "https://openrouter.ai/api/v1/",
  --           model = "anthropic/claude-3.5-sonnet:beta",
  --           temperature = 0,
  --           max_tokens = 8192,
  --         },
  --       },
  --       behaviour = {
  --         auto_suggestions = false, -- Experimental stage
  --         auto_set_highlight_group = true,
  --         auto_set_keymaps = true,
  --         auto_apply_diff_after_generation = false,
  --         support_paste_from_clipboard = false,
  --         minimize_diff = true,
  --       },
  --     })
  --   end,
  --   keys = {
  --     {
  --       "<leader>aa",
  --       function()
  --         require("avante.api").ask()
  --       end,
  --       desc = "avante: ask",
  --       mode = { "n", "v" },
  --     },
  --     {
  --       "<leader>ae",
  --       function()
  --         require("avante.api").edit()
  --       end,
  --       desc = "avante: edit",
  --       mode = "v",
  --     },
  --   },
  --   dependencies = {
  --     "zbirenbaum/copilot.lua", -- for providers='copilot'
  --     "stevearc/dressing.nvim",
  --     "nvim-lua/plenary.nvim",
  --     "MunifTanjim/nui.nvim",
  --     "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
  --     {
  --       -- support for image pasting
  --       "HakonHarnes/img-clip.nvim",
  --       event = "VeryLazy",
  --       opts = {
  --         -- recommended settings
  --         default = {
  --           embed_image_as_base64 = false,
  --           prompt_for_file_name = false,
  --           drag_and_drop = {
  --             insert_mode = true,
  --           },
  --           -- required for Windows users
  --           use_absolute_path = true,
  --         },
  --       },
  --     },
  --     {
  --       -- Make sure to set this up properly if you have lazy=true
  --       "MeanderingProgrammer/render-markdown.nvim",
  --       opts = {
  --         file_types = { "markdown", "Avante" },
  --       },
  --       ft = { "markdown", "Avante" },
  --     },
  --   },
  -- },
}
