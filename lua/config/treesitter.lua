local M = {}

--- enables treesitter parsers for the given file types
---@param file_types string[]
function M.enable_parsers(file_types)
  vim.api.nvim_create_autocmd({ 'FileType' }, {
    pattern = file_types,
    callback = function(event)
      -- this enables highlight too
      vim.treesitter.start(event.buf)

      -- enable indentation
      vim.bo.indentexpr = 'v:lua.require("nvim-treesitter").indentexpr()'
    end,
  })
end

-- parsers to install automatically
local ensure_installed = {
  'c',
  'lua',
  'vim',
  'vimdoc',
  'python',
  'ruby',
  'yaml',
  'json',
  'go',
  'rust',
  'bash',
  'markdown',
  'html',
  'css',
  'javascript',
}

-- additional filetypes: useful when the parser name is different from ft
local additional_filetypes = { 'sh' }

if #ensure_installed > 0 then
  local nts = require('nvim-treesitter')
  nts.install(ensure_installed)

  -- all the installed parsers
  local parsers = nts.get_installed()

  M.enable_parsers(vim.tbl_extend('force', parsers, additional_filetypes))
end

require('nvim-treesitter-textobjects').setup({
  select = {
    -- Automatically jump forward to textobj, similar to targets.vim
    lookahead = true,
    -- You can choose the select mode (default is charwise 'v')
    --
    -- Can also be a function which gets passed a table with the keys
    -- * query_string: eg '@function.inner'
    -- * method: eg 'v' or 'o'
    -- and should return the mode ('v', 'V', or '<c-v>') or a table
    -- mapping query_strings to modes.
    selection_modes = {
      ['@parameter.outer'] = 'v', -- charwise
      ['@function.outer'] = 'V', -- linewise
      ['@class.outer'] = '<c-v>', -- blockwise
    },
    -- If you set this to `true` (default is `false`) then any textobject is
    -- extended to include preceding or succeeding whitespace. Succeeding
    -- whitespace has priority in order to act similarly to eg the built-in
    -- `ap`.
    --
    -- Can also be a function which gets passed a table with the keys
    -- * query_string: eg '@function.inner'
    -- * selection_mode: eg 'v'
    -- and should return true of false
    include_surrounding_whitespace = false,
  },
  move = {
    set_jumps = true,
  },
})

local select_keymaps = {
  -- You can use the capture groups defined in textobjects.scm
  ['aa'] = '@parameter.outer',
  ['ia'] = '@parameter.inner',
  ['af'] = '@function.outer',
  ['if'] = '@function.inner',
  ['am'] = '@function.outer',
  ['im'] = '@function.inner',
  ['ac'] = '@class.outer',
  ['ic'] = '@class.inner',
  ['ab'] = '@block.outer',
  ['ib'] = '@block.inner',
}

for k, v in pairs(select_keymaps) do
  vim.keymap.set({ 'x', 'o' }, k, function()
    require('nvim-treesitter-textobjects.select').select_textobject(v, 'textobjects')
  end, { desc = 'ts-textobjects: select ' .. v })
end

local move_keymaps = {
  goto_next_start = {
    [']m'] = '@function.outer',
    [']b'] = '@block.outer',
    [']]'] = '@class.outer',
  },
  goto_next_end = {
    [']M'] = '@function.outer',
    [']B'] = '@block.outer',
    [']['] = '@class.outer',
  },
  goto_previous_start = {
    ['[m'] = '@function.outer',
    ['[b'] = '@block.outer',
    ['[['] = '@class.outer',
  },
  goto_previous_end = {
    ['[M'] = '@function.outer',
    ['[B'] = '@block.outer',
    ['[]'] = '@class.outer',
  },
}

for fn, maps in pairs(move_keymaps) do
  for k, v in pairs(maps) do
    vim.keymap.set({ 'n', 'x', 'o' }, k, function()
      require('nvim-treesitter-textobjects.move')[fn](v, 'textobjects')
    end, { desc = 'ts-textobjects: ' .. fn .. ' ' .. v })
  end
end

vim.keymap.set('n', '<leader>a', function()
  require('nvim-treesitter-textobjects.swap').swap_next('@parameter.inner')
end)
vim.keymap.set('n', '<leader>A', function()
  require('nvim-treesitter-textobjects.swap').swap_previous('@parameter.outer')
end)

local repeatable_move = require('nvim-treesitter-textobjects.repeatable_move')

-- workaround for https://github.com/nvim-treesitter/nvim-treesitter-textobjects/issues/775
-- thanks @seandewar
local function make_repeat_rhs(dir)
  return function()
    local keys = repeatable_move['repeat_last_move_' .. dir]()
    if keys then
      vim.cmd(('normal! %d%s'):format(vim.v.count1, vim.keycode(keys)))
    end
  end
end

vim.keymap.set({ 'n', 'x', 'o' }, ';', make_repeat_rhs('next'))
vim.keymap.set({ 'n', 'x', 'o' }, ',', make_repeat_rhs('previous'))

-- Optionally, make builtin f, F, t, T also repeatable with ; and ,
vim.keymap.set({ 'n', 'x', 'o' }, 'f', repeatable_move.builtin_f_expr, { expr = true })
vim.keymap.set({ 'n', 'x', 'o' }, 'F', repeatable_move.builtin_F_expr, { expr = true })
vim.keymap.set({ 'n', 'x', 'o' }, 't', repeatable_move.builtin_t_expr, { expr = true })
vim.keymap.set({ 'n', 'x', 'o' }, 'T', repeatable_move.builtin_T_expr, { expr = true })

return M
