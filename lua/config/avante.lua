require('avante').setup({
  -- agentic or legacy
  mode = 'agentic',
  provider = 'gemini',
  -- WARNING: Since auto-suggestions are a high-frequency operation and therefore expensive,
  -- currently designating it as `copilot` provider is dangerous because: https://github.com/yetone/avante.nvim/issues/1048
  -- Of course, you can reduce the request frequency by increasing `suggestion.debounce`.
  auto_suggestions_provider = nil,
  providers = {
    gemini = {
      model = 'gemini-2.5-pro',
    },
    gemini_flash = {
      model = 'gemini-2.5-flash',
      __inherited_from = 'gemini',
    },
    gemini_flash_lite = {
      model = 'gemini-2.5-flash-lite',
      __inherited_from = 'gemini',
    },
    gemini_2_0_flash = {
      model = 'gemini-2.0-flash',
      __inherited_from = 'gemini',
    },
    gemini_2_0_flash_lite = {
      model = 'gemini-2.0-flash-lite',
      __inherited_from = 'gemini',
    },
    -- ollama = {
    --   endpoint = 'http://localhost:11434',
    --   model = 'codellama:7b',
    -- },
  },
  windows = {
    ask = {
      -- do not auto enter insert mode in prompt input window
      start_insert = false,
    },
  },
})

require('config.treesitter').enable_parsers({ 'Avante' })
