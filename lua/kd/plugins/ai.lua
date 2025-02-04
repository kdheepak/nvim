local prompt = {
  grammar_correction = "Correct the text to standard English, but keep any code blocks inside intact.",
  code_readability_analysis = [[
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
  optimize_code = "Optimize the following code",
  summarize = "Summarize the following text",
  translate = "Translate this into French, but keep any code blocks inside intact",
  explain_code = "Explain the following code",
  complete_code = function()
    return "Complete the following codes written in " .. vim.bo.filetype
  end,
  add_docstring = "Add docstring to the following codes",
  fix_bugs = "Fix the bugs inside the following codes if any",
  add_tests = "Implement tests for the following code",
  extract_keywords = "Extract the main keywords from the following text",
  diagnostics = "Fix the diagnostics inside the following code if any @diagnostics",
  git_diff = function()
    local commit_prompt = [[
    Write commit message with commitizen convention based on the following diff.

    ```
    ]] .. vim.fn.system("git diff") .. [[
    ```

    Write clear, informative commit messages that explain the 'what' and 'why' behind changes, not just the 'how'.
    ]]
    return commit_prompt
  end,
}

local function ask(question)
  return function()
    question = vim.is_callable(question) and question() or question
    require("avante.api").ask({ question = question })
  end
end

-- prefill edit window with common scenarios to avoid repeating query and submit immediately
local function edit_submit(question)
  return function()
    question = vim.is_callable(question) and question() or question
    require("avante.api").edit()
    vim.api.nvim_buf_set_lines(vim.api.nvim_get_current_buf(), 0, -1, false, { question })
    -- optionally set the cursor position to the end of the input
    vim.api.nvim_win_set_cursor(vim.api.nvim_get_current_win(), { 1, #question + 1 })
    -- simulate ctrl+s keypress to submit
    vim.api.nvim_feedkeys(vim.keycode("<C-s>"), "m", false)
  end
end

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
      require("avante_lib").load()
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
        desc = "Avante: Ask",
        mode = { "n", "v" },
      },
      { "<leader>av", "", desc = "+avante", mode = { "n", "v" } },
      {
        "<leader>ae",
        function()
          require("avante.api").edit()
        end,
        desc = "Avante: Edit",
        mode = "v",
      },
      {
        "<leader>ar",
        function()
          require("avante.api").refresh()
        end,
        desc = "Avante: Refresh",
      },
      { "<leader>av", "", desc = "+avante", mode = { "n", "v" } },
      {
        "<leader>avi",
        ask(prompt.grammar_correction),
        desc = "Grammar Correction (Ask)",
        mode = { "n", "v" },
      },
      {
        "<leader>avr",
        ask(prompt.code_readability_analysis),
        desc = "Code Readability Analysis (Ask)",
        mode = { "n", "v" },
      },
      {
        "<leader>avo",
        ask(prompt.optimize_code),
        desc = "Optimize Code (Ask)",
        mode = { "n", "v" },
      },
      { "<leader>avO", edit_submit(prompt.optimize_code), desc = "Optimize Code (Edit)", mode = "v" },
      {
        "<leader>avs",
        ask(prompt.summarize),
        desc = "Summarize text (Ask)",
        mode = { "n", "v" },
      },
      {
        "<leader>avt",
        ask(prompt.translate),
        desc = "Translate text (Ask)",
        mode = { "n", "v" },
      },
      {
        "<leader>ave",
        ask(prompt.explain_code),
        desc = "Explain Code (Ask)",
        mode = { "n", "v" },
      },
      {
        "<leader>avc",
        ask(prompt.complete_code),
        desc = "Complete Code (Ask)",
        mode = { "n", "v" },
      },
      {
        "<leader>avd",
        ask(prompt.add_docstring),
        desc = "Docstring (Ask)",
        mode = { "n", "v" },
      },
      { "<leader>avD", edit_submit(prompt.add_docstring), desc = "Docstring (Edit)", mode = "v" },
      {
        "<leader>avf",
        ask(prompt.fix_bugs),
        desc = "Fix Bugs (Ask)",
        mode = { "n", "v" },
      },
      { "<leader>avF", edit_submit(prompt.fix_bugs), desc = "Fix Bugs (Edit)", mode = "v" },
      {
        "<leader>avu",
        ask(prompt.add_tests),
        desc = "Add Tests (Ask)",
        mode = { "n", "v" },
      },
      { "<leader>avU", edit_submit(prompt.add_tests), desc = "Add Tests (Edit)", mode = "v" },
      {
        "<leader>avm",
        ask(prompt.extract_keywords),
        mode = { "n", "v" },
        desc = "Extract Keywords (Ask)",
      },
      {
        "<leader>avM",
        ask(prompt.extract_keywords),
        mode = { "v" },
        desc = "Extract Keywords (Edit)",
      },
      {
        "<leader>avh",
        ask(prompt.diagnostics),
        mode = { "n", "v" },
        desc = "Fix Help Diagnostics",
      },
      {
        "<leader>avg",
        ask(prompt.git_diff),
        mode = { "n", "v" },
        desc = "Git Commit Message",
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
