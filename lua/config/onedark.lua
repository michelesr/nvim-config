require('onedark').setup({
  toggle_style_key = '<Plug>(OneDarkToggleKey)',
  -- bundle/onedark.nvim/lua/onedark/palette.lua
  style = 'dark',
  colors = {
    bg0 = '#1d1d2d',
    fg = '#bdcdcd',
    grey = '#6d7d7d',
  },

  -- bundle/onedark.nvim/lua/onedark/highlights.lua
  highlights = {
    VertSplit = { fg = '#8ffc67' },
    StatusLine = { bg = '#222222' },
    StatusLineNC = { bg = '#222222' },
    NormalFloat = { bg = '#222738' },
    PMenu = { bg = '#222738' },
    RenderMarkdownCode = { bg = '#222738' },
  },
})
require('onedark').load()
