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
    local hunk_move = require('nvim-treesitter-textobjects.repeatable_move').make_repeatable_move(function(opts)
      if opts.forward then
        gitsigns.nav_hunk('next')
      else
        gitsigns.nav_hunk('prev')
      end
    end)

    -- Navigation
    map('n', ']h', function()
      if vim.wo.diff then
        vim.cmd.normal({ ']h', bang = true })
      else
        hunk_move({ forward = true })
      end
    end, { desc = 'Next hunk' })

    map('n', '[h', function()
      if vim.wo.diff then
        vim.cmd.normal({ '[h', bang = true })
      else
        hunk_move({ forward = false })
      end
    end, { desc = 'Prev hunk' })

    -- Text object
    map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
    map({ 'o', 'x' }, 'ah', ':<C-U>Gitsigns select_hunk<CR>')
  end,
})
