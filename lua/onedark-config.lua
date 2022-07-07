-- Lua
require('onedark').setup {
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
    StatusLine = { bg = '#31353f' },
    StatusLineNC = { bg = '#31353f' },
  }
}
require('onedark').load()
