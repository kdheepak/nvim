return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    config = function()
      require("copilot").setup({
        suggestion = {
          enabled = false,
          auto_trigger = false,
          debounce = 75,
          keymap = {
            accept = "<M-l>",
            accept_word = false,
            accept_line = false,
            next = "<M-]>",
            prev = "<M-[>",
            dismiss = false,
          },
          panel = { enabled = false },
          filetypes = {
            yaml = true,
            markdown = true,
          },
        },
      })
    end,
  },
  {
    "yetone/avante.nvim",
    cmd = "AvanteAsk",
    build = "make",
    config = function()
      require("avante").setup({
        provider = "copilot",
        vendors = {
          claude_sonnet = {
            __inherited_from = "openai",
            api_key_name = "OPENROUTER_API_KEY",
            endpoint = "https://openrouter.ai/api/v1/",
            model = "anthropic/claude-3.5-sonnet:beta",
            temperature = 0,
            max_tokens = 8192,
          },
        },
        behaviour = {
          auto_suggestions = false, -- Experimental stage
          auto_set_highlight_group = true,
          auto_set_keymaps = true,
          auto_apply_diff_after_generation = false,
          support_paste_from_clipboard = false,
          minimize_diff = true,
        },
      })
    end,
    keys = {
      {
        "<leader>a",
        group = "+Avante",
      },
      {
        "<leader>aa",
        function()
          require("avante.api").ask()
        end,
        desc = "Avante: ask a question",
        mode = { "n", "v" },
      },
      {
        "<leader>ae",
        function()
          require("avante.api").edit()
        end,
        desc = "avante: edit selected text",
        mode = "v",
      },
      {
        "<leader>apg",
        function()
          require("avante.api").ask({
            question = "Correct the text to standard English, but keep any code blocks inside intact.",
          })
        end,
        mode = { "n", "v" },
        desc = "Grammar Correction",
      },
      {
        "<leader>app",
        function()
          require("avante.api").ask({
            question = "Generate a concise and meaningful git commit message for the following changes",
          })
        end,
        mode = { "n" },
        desc = "Automate Git Commit",
      },
      {
        "<leader>apm",
        function()
          require("avante.api").ask({ question = "Extract the main keywords from the following text" })
        end,
        mode = { "n", "v" },
        desc = "Extract Main Keywords",
      },
      {
        "<leader>apr",
        function()
          require("avante.api").ask({
            question = [[
    You must identify any readability issues in the code snippet.
    Some readability issues to consider:
    - Unclear naming
    - Unclear purpose
    - Redundant or obvious comments
    - Lack of comments
    - Long or complex one liners
    - Too much nesting
    - Long variable names
    - Inconsistent naming and code style.
    - Code repetition
    You may identify additional problems. The user submits a small section of code from a larger file.
    Only list lines with readability issues, in the format <line_num>|<issue and proposed solution>
    If there's no issues with code respond with only: <OK>
  ]],
          })
        end,
        mode = { "n", "v" },
        desc = "Code Readability Analysis",
      },
      {
        "<leader>apo",
        function()
          require("avante.api").ask({ question = "Optimize the following code" })
        end,
        mode = { "n", "v" },
        desc = "Optimize Code",
      },
      {
        "<leader>aps",
        function()
          require("avante.api").ask({ question = "Summarize the following text" })
        end,
        mode = { "n", "v" },
        desc = "Summarize text",
      },
      {
        "<leader>apt",
        function()
          require("avante.api").ask({ question = "Translate this into French, but keep any code blocks inside intact" })
        end,
        mode = { "n", "v" },
        desc = "Translate text",
      },
      {
        "<leader>ape",
        function()
          require("avante.api").ask({ question = "Explain the following code" })
        end,
        mode = { "n", "v" },
        desc = "Explain Code",
      },
      {
        "<leader>apc",
        function()
          require("avante.api").ask({ question = "Complete the following code written in " .. vim.bo.filetype })
        end,
        mode = { "n", "v" },
        desc = "Complete Code",
      },
      {
        "<leader>apD",
        function()
          require("avante.api").ask({ question = "Add docstring to the following code" })
        end,
        mode = { "n", "v" },
        desc = "Add Docstring",
      },
      {
        "<leader>apd",
        function()
          require("avante.api").ask({ question = "Fix the diagnostics inside the following code if any @diagnostics" })
        end,
        mode = { "n", "v" },
        desc = "Fix Diagnostics",
      },
      {
        "<leader>apb",
        function()
          require("avante.api").ask({ question = "Fix the bugs inside the following codes if any" })
        end,
        mode = { "n", "v" },
        desc = "Fix Bugs",
      },
      {
        "<leader>apt",
        function()
          require("avante.api").ask({ question = "Implement tests for the following code" })
        end,
        mode = { "n", "v" },
        desc = "Add Tests",
      },
    },
    dependencies = {
      "zbirenbaum/copilot.lua",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  },
}
