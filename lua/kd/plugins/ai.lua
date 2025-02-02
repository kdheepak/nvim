return {
  "yetone/avante.nvim",
  cmd = "AvanteAsk",
  build = "make",
  config = function()
    require("avante").setup({
      provider = "openrouter",
      vendors = {
        openrouter = {
          api_key_name = "OPENROUTER_API_KEY",
          endpoint = "https://openrouter.ai/api/v1/chat/completions",
          -- model = "anthropic/claude-3.5-sonnet",
          model = "deepseek/deepseek-chat",
          parse_curl_args = function(opts, code_opts)
            return {
              url = opts.endpoint,
              headers = {
                ["Content-Type"] = "application/json",
                ["Authorization"] = "Bearer " .. os.getenv(opts.api_key_name),
              },
              body = {
                model = opts.model,
                messages = require("avante.providers").openai.parse_messages(code_opts), -- you can make your own message, but this is very advanced
                temperature = 0,
                max_tokens = 4096,
                stream = true,
              },
            }
          end,
          parse_response_data = function(data_stream, event_state, opts)
            require("avante.providers").openai.parse_response(data_stream, event_state, opts)
          end,
        },
      },
      openai = {
        endpoint = "https://api.openai.com/v1",
        model = "gpt-3.5-turbo",
        timeout = 30000, -- Timeout in milliseconds
        temperature = 0,
        max_tokens = 4096,
        ["local"] = false,
      },
    })
  end,
  keys = {
    {
      "<leader>aa",
      function()
        require("avante.api").ask()
      end,
      desc = "avante: ask",
      mode = { "n", "v" },
    },
    {
      "<leader>ae",
      function()
        require("avante.api").edit()
      end,
      desc = "avante: edit",
      mode = "v",
    },
  },
  dependencies = {
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
    "MeanderingProgrammer/render-markdown.nvim",
  },
}
