-- prefil edit window with common scenarios to avoid repeating query and submit immediately
local prefill_edit_window = function(request)
  require("avante.api").edit()
  local code_bufnr = vim.api.nvim_get_current_buf()
  local code_winid = vim.api.nvim_get_current_win()
  if code_bufnr == nil or code_winid == nil then
    return
  end
  vim.api.nvim_buf_set_lines(code_bufnr, 0, -1, false, { request })
  -- Optionally set the cursor position to the end of the input
  vim.api.nvim_win_set_cursor(code_winid, { 1, #request + 1 })
  -- Simulate Ctrl+S keypress to submit
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-s>", true, true, true), "v", true)
end

local constants = {
  LLM_ROLE = "llm",
  USER_ROLE = "user",
  SYSTEM_ROLE = "system",
}

return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    config = function()
      require("copilot").setup({
        suggestion = {
          enabled = true,
          auto_trigger = true,
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
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      {
        "MeanderingProgrammer/render-markdown.nvim",
        ft = { "markdown", "codecompanion" },
      },
    },
    config = function()
      require("codecompanion").setup({
        display = {
          action_palette = {
            opts = {
              show_default_actions = true,
              show_default_prompt_library = true,
            },
          },
        },
        strategies = {
          chat = {
            adapter = "copilot",
          },
          inline = {
            adapter = "copilot",
          },
          agent = {
            adapter = "copilot",
          },
        },
        adapters = {
          copilot = function()
            return require("codecompanion.adapters").extend("copilot", {
              schema = {
                model = {
                  default = "gpt-4o-2024-05-13",
                },
              },
            })
          end,
        },
        prompt_library = {
          ["Code Expert"] = {
            strategy = "chat",
            description = "Get some special advice from an LLM",
            opts = {
              mapping = "<LocalLeader>ce",
              modes = { "v" },
              short_name = "expert",
              auto_submit = true,
              stop_context_insertion = true,
              user_prompt = true,
            },
            prompts = {
              {
                role = constants.SYSTEM_ROLE,
                content = function(context)
                  return "I want you to act as a senior "
                    .. context.filetype
                    .. " developer. I will ask you specific questions and I want you to return concise explanations and codeblock examples."
                end,
              },
              {
                role = constants.USER_ROLE,
                content = function(context)
                  local text = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)

                  return "I have the following code:\n\n```" .. context.filetype .. "\n" .. text .. "\n```\n\n"
                end,
                opts = {
                  contains_code = true,
                },
              },
            },
          },
          ["Summarize"] = {
            strategy = "chat",
            description = "Summarize some text",
            opts = {
              index = 3,
              is_default = true,
              modes = { "v" },
              short_name = "summarize",
              is_slash_cmd = false,
              auto_submit = true,
              user_prompt = false,
              stop_context_insertion = true,
            },
            prompts = {
              {
                role = constants.SYSTEM_ROLE,
                content = [[I want you to act as a senior editor at a newspaper whose job is to make short summaries of articles for search engines.]],
                opts = {
                  visible = false,
                  tag = "system_tag",
                },
              },
              {
                role = constants.USER_ROLE,
                content = function(context)
                  local prose = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)
                  return string.format(
                    [[Summarize the contents of the article that starts below the "---". Make your summary be 150 to 170 characters long to fit in a web page meta description:

                ---
                %s

                Summarize that in 150 characters.
                ]],
                    prose
                  )
                end,
              },
            },
          },
          ["Docstring"] = {
            strategy = "inline",
            description = "Generate docstring for this function",
            opts = {
              modes = { "v" },
              short_name = "docstring",
              auto_submit = true,
              stop_context_insertion = true,
              user_prompt = false,
            },
            prompts = {
              {
                role = constants.SYSTEM_ROLE,
                content = function(context)
                  return "I want you to act as a senior "
                    .. context.filetype
                    .. " developer. I will send you a function and I want you to generate the docstrings for the function using the numpy format. Generate only the docstrings and nothing more. Put the generated docstring at the correct position in the code. Use tabs instead of spaces"
                end,
              },
              {
                role = constants.USER_ROLE,
                content = function(context)
                  local text = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)

                  return text
                end,
                opts = {
                  visible = false,
                  placement = "add",
                  contains_code = true,
                },
              },
            },
          },
        },
      })
      vim.api.nvim_set_keymap("n", "<Leader>ap", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap("v", "<Leader>ap", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap("n", "<Leader>aa", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap("v", "<Leader>aa", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap("v", "ga", "<cmd>CodeCompanionChat Add<cr>", { noremap = true, silent = true })
    end,
  },
  -- {
  --   "CopilotC-Nvim/CopilotChat.nvim",
  --   config = function(_, opts)
  --     local chat = require("CopilotChat")
  --     chat.setup(opts)
  --   end,
  --   build = "make tiktoken",
  --   branch = "main",
  --   keys = {
  --     { "<c-s>", "<CR>", ft = "copilot-chat", desc = "Submit Prompt", remap = true },
  --     { "<leader>a", "", desc = "+ai", mode = { "n", "v" } },
  --     {
  --       "<leader>aa",
  --       function()
  --         return require("CopilotChat").toggle()
  --       end,
  --       desc = "CopilotChat - Toggle",
  --       mode = { "n", "v" },
  --     },
  --     {
  --       "<leader>ax",
  --       function()
  --         return require("CopilotChat").reset()
  --       end,
  --       desc = "CopilotChat - clear",
  --       mode = { "n", "v" },
  --     },
  --     {
  --       "<leader>aq",
  --       function()
  --         local input = vim.fn.input("Quick Chat: ")
  --         if input ~= "" then
  --           require("CopilotChat").ask(input)
  --         end
  --       end,
  --       desc = "CopilotChat - Quick Chat",
  --       mode = { "n", "v" },
  --     },
  --     -- Show prompts actions with telescope
  --     {
  --       "<leader>ap",
  --       function()
  --         local actions = require("CopilotChat.actions")
  --         require("CopilotChat.integrations.fzflua").pick(actions.prompt_actions())
  --       end,
  --       desc = "CopilotChat - Prompt actions",
  --     },
  --     -- Show help actions with fzf-lua
  --     {
  --       "<leader>ah",
  --       function()
  --         local actions = require("CopilotChat.actions")
  --         require("CopilotChat.integrations.fzflua").pick(actions.help_actions())
  --       end,
  --       desc = "CopilotChat - Help actions",
  --     },
  --     -- Code related commands
  --     { "<leader>ae", "<cmd>CopilotChatExplain<cr>", desc = "CopilotChat - Explain code" },
  --     { "<leader>at", "<cmd>CopilotChatTests<cr>", desc = "CopilotChat - Generate tests" },
  --     { "<leader>ar", "<cmd>CopilotChatReview<cr>", desc = "CopilotChat - Review code" },
  --     { "<leader>aR", "<cmd>CopilotChatRefactor<cr>", desc = "CopilotChat - Refactor code" },
  --     { "<leader>an", "<cmd>CopilotChatBetterNamings<cr>", desc = "CopilotChat - Better Naming" },
  --     -- Chat with Copilot in visual mode
  --     {
  --       "<leader>av",
  --       ":CopilotChatVisual<cr>",
  --       mode = "x",
  --       desc = "CopilotChat - Open in vertical split",
  --     },
  --     {
  --       "<leader>aI",
  --       "<cmd>CopilotChatInline<cr>",
  --       desc = "CopilotChat - Inline chat",
  --     },
  --     -- Custom input for CopilotChat
  --     {
  --       "<leader>ai",
  --       function()
  --         local input = vim.fn.input("Ask Copilot: ")
  --         if input ~= "" then
  --           vim.cmd("CopilotChat " .. input)
  --         end
  --       end,
  --       desc = "CopilotChat - Ask input",
  --     },
  --     -- Generate commit message based on the git diff
  --     {
  --       "<leader>am",
  --       "<cmd>CopilotChatCommit<cr>",
  --       desc = "CopilotChat - Generate commit message for staged changes",
  --     },
  --     -- Quick chat with Copilot
  --     {
  --       "<leader>aq",
  --       function()
  --         local input = vim.fn.input("Quick Chat: ")
  --         if input ~= "" then
  --           vim.cmd("CopilotChatBuffer " .. input)
  --         end
  --       end,
  --       desc = "CopilotChat - Quick chat",
  --     },
  --     -- Debug
  --     { "<leader>ad", "<cmd>CopilotChatDebugInfo<cr>", desc = "CopilotChat - Debug Info" },
  --     -- Fix the issue with diagnostic
  --     { "<leader>af", "<cmd>CopilotChatFix<cr>", desc = "CopilotChat - Fix Diagnostic" },
  --     -- Clear buffer and chat history
  --     { "<leader>al", "<cmd>CopilotChatReset<cr>", desc = "CopilotChat - Clear buffer and chat history" },
  --     -- Toggle Copilot Chat Vsplit
  --     { "<leader>av", "<cmd>CopilotChatToggle<cr>", desc = "CopilotChat - Toggle" },
  --     -- Copilot Chat Models
  --     { "<leader>a?", "<cmd>CopilotChatModels<cr>", desc = "CopilotChat - Select Models" },
  --   },
  -- },
  --   {
  --     "yetone/avante.nvim",
  --     cmd = "AvanteAsk",
  --     build = "make",
  --     config = function()
  --       require("avante").setup({
  --         provider = "copilot",
  --         vendors = {
  --           claude_sonnet = {
  --             __inherited_from = "openai",
  --             api_key_name = "OPENROUTER_API_KEY",
  --             endpoint = "https://openrouter.ai/api/v1/",
  --             model = "anthropic/claude-3.5-sonnet:beta",
  --             temperature = 0,
  --             max_tokens = 8192,
  --           },
  --         },
  --         behaviour = {
  --           auto_suggestions = false, -- Experimental stage
  --           auto_set_highlight_group = true,
  --           auto_set_keymaps = true,
  --           auto_apply_diff_after_generation = false,
  --           support_paste_from_clipboard = false,
  --           minimize_diff = true,
  --         },
  --       })
  --     end,
  --     keys = {
  --       {
  --         "<leader>aa",
  --         function()
  --           require("avante.api").ask()
  --         end,
  --         desc = "avante: ask",
  --         mode = { "n", "v" },
  --       },
  --       {
  --         "<leader>ae",
  --         function()
  --           require("avante.api").edit()
  --         end,
  --         desc = "avante: edit",
  --         mode = "v",
  --       },
  --       {
  --         "<leader>apg",
  --         function()
  --           require("avante.api").ask({
  --             question = "Correct the text to standard English, but keep any code blocks inside intact.",
  --           })
  --         end,
  --         mode = { "n", "v" },
  --         desc = "Grammar Correction",
  --       },
  --       {
  --         "<leader>apm",
  --         function()
  --           require("avante.api").ask({ question = "Extract the main keywords from the following text" })
  --         end,
  --         mode = { "n", "v" },
  --         desc = "Extract Main Keywords",
  --       },
  --       {
  --         "<leader>apr",
  --         function()
  --           require("avante.api").ask({
  --             question = [[
  --   You must identify any readability issues in the code snippet.
  --   Some readability issues to consider:
  --   - Unclear naming
  --   - Unclear purpose
  --   - Redundant or obvious comments
  --   - Lack of comments
  --   - Long or complex one liners
  --   - Too much nesting
  --   - Long variable names
  --   - Inconsistent naming and code style.
  --   - Code repetition
  --   You may identify additional problems. The user submits a small section of code from a larger file.
  --   Only list lines with readability issues, in the format <line_num>|<issue and proposed solution>
  --   If there's no issues with code respond with only: <OK>
  -- ]],
  --           })
  --         end,
  --         mode = { "n", "v" },
  --         desc = "Code Readability Analysis",
  --       },
  --       {
  --         "<leader>apo",
  --         function()
  --           require("avante.api").ask({ question = "Optimize the following code" })
  --         end,
  --         mode = { "n", "v" },
  --         desc = "Optimize Code",
  --       },
  --       {
  --         "<leader>aps",
  --         function()
  --           require("avante.api").ask({ question = "Summarize the following text" })
  --         end,
  --         mode = { "n", "v" },
  --         desc = "Summarize text",
  --       },
  --       {
  --         "<leader>apt",
  --         function()
  --           require("avante.api").ask({ question = "Translate this into French, but keep any code blocks inside intact" })
  --         end,
  --         mode = { "n", "v" },
  --         desc = "Translate text",
  --       },
  --       {
  --         "<leader>ape",
  --         function()
  --           require("avante.api").ask({ question = "Explain the following code" })
  --         end,
  --         mode = { "n", "v" },
  --         desc = "Explain Code",
  --       },
  --       {
  --         "<leader>apc",
  --         function()
  --           require("avante.api").ask({ question = "Complete the following code written in " .. vim.bo.filetype })
  --         end,
  --         mode = { "n", "v" },
  --         desc = "Complete Code",
  --       },
  --       {
  --         "<leader>apD",
  --         function()
  --           require("avante.api").ask({ question = "Add docstring to the following code" })
  --         end,
  --         mode = { "n", "v" },
  --         desc = "Add Docstring",
  --       },
  --       {
  --         "<leader>apd",
  --         function()
  --           require("avante.api").ask({ question = "Fix the diagnostics inside the following code if any @diagnostics" })
  --         end,
  --         mode = { "n", "v" },
  --         desc = "Fix Diagnostics",
  --       },
  --       {
  --         "<leader>apb",
  --         function()
  --           require("avante.api").ask({ question = "Fix the bugs inside the following codes if any" })
  --         end,
  --         mode = { "n", "v" },
  --         desc = "Fix Bugs",
  --       },
  --       {
  --         "<leader>apt",
  --         function()
  --           require("avante.api").ask({ question = "Implement tests for the following code" })
  --         end,
  --         mode = { "n", "v" },
  --         desc = "Add Tests",
  --       },
  --     },
  --     dependencies = {
  --       "zbirenbaum/copilot.lua", -- for providers='copilot'
  --       "stevearc/dressing.nvim",
  --       "nvim-lua/plenary.nvim",
  --       "MunifTanjim/nui.nvim",
  --       "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
  --       {
  --         -- support for image pasting
  --         "HakonHarnes/img-clip.nvim",
  --         event = "VeryLazy",
  --         opts = {
  --           -- recommended settings
  --           default = {
  --             embed_image_as_base64 = false,
  --             prompt_for_file_name = false,
  --             drag_and_drop = {
  --               insert_mode = true,
  --             },
  --             -- required for Windows users
  --             use_absolute_path = true,
  --           },
  --         },
  --       },
  --       {
  --         -- Make sure to set this up properly if you have lazy=true
  --         "MeanderingProgrammer/render-markdown.nvim",
  --         opts = {
  --           file_types = { "markdown", "Avante" },
  --         },
  --         ft = { "markdown", "Avante" },
  --       },
  --     },
  --   },
}
