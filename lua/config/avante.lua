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
    -- ollama = {
    --   endpoint = 'http://localhost:11434',
    --   model = 'codellama:7b',
    -- },
  },
  selector = {
    provider = 'telescope',
  },
})

require('config.treesitter').enable_parsers({ 'Avante' })
