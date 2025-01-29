require('gitsigns').setup({
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
  on_attach = function(bufnr)
    local gitsigns = require('gitsigns')

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- wrap next and prev hunk functions to be repeatable with , and ; just like native vim f command
    local ts_repeat = require('nvim-treesitter.textobjects.repeatable_move').make_repeatable_move_pair
    local next_hunk, prev_hunk = ts_repeat(function()
      gitsigns.nav_hunk('next')
    end, function()
      gitsigns.nav_hunk('prev')
    end)

    -- Navigation
    map('n', ']h', function()
      if vim.wo.diff then
        vim.cmd.normal({ ']h', bang = true })
      else
        next_hunk()
      end
    end, { desc = 'Next hunk' })

    map('n', '[h', function()
      if vim.wo.diff then
        vim.cmd.normal({ '[h', bang = true })
      else
        prev_hunk()
      end
    end, { desc = 'Prev hunk' })

    -- Text object
    map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
    map({ 'o', 'x' }, 'ah', ':<C-U>Gitsigns select_hunk<CR>')
  end,
})
