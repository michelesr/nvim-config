-- Lua
require('onedark').setup {
  -- bundle/onedark.nvim/lua/onedark/palette.lua
  style = 'dark',
  colors = {
    bg0 = '#1d1d2d',
    fg = '#bdcdcd',
  },

  -- bundle/onedark.nvim/lua/onedark/highlights.lua
  highlights = {}
}
require('onedark').load()
