local gps = require("nvim-gps")

gps.setup {
  disable_icons = false,
}

-- prints an icon in the statusline when LSP are busy
local function lsp_activity()
  if require('lsp-activity-check').busy then
    return '羽'
  end
  return ''
end

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {},
    always_divide_middle = true,
    globalstatus = false,
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {
      {'filename', path = 1},
      { gps.get_location, cond = gps.is_available },
    },
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location', lsp_activity}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {
      {'filename', path = 1}
    },
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {
    lualine_a = {
      -- take all the space
      {'tabs', mode = 1, max_length = vim.o.columns}
    }
  },
  extensions = {}
}
