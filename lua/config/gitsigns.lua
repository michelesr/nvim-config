require('gitsigns').setup({
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
        vim.cmd.normal({ ']c', bang = true })
      else
        next_hunk()
      end
    end, { desc = 'Next hunk' })

    map('n', '[h', function()
      if vim.wo.diff then
        vim.cmd.normal({ '[c', bang = true })
      else
        prev_hunk()
      end
    end, { desc = 'Prev hunk' })

    -- Actions
    map('n', '<leader>hs', gitsigns.stage_hunk, { desc = '[S]tage [H]unk' })
    map('n', '<leader>hr', gitsigns.reset_hunk, { desc = '[R]eset [H]unk' })

    map('v', '<leader>hs', function()
      gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
    end, { desc = '[S]tage [H]unk' })

    map('v', '<leader>hr', function()
      gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
    end, { desc = '[R]eset [H]unk' })

    map('n', '<leader>hS', gitsigns.stage_buffer, { desc = '[S]tage [B]uffer' })
    map('n', '<leader>hR', gitsigns.reset_buffer, { desc = '[R]eset [B]uffer' })
    map('n', '<leader>hp', gitsigns.preview_hunk, { desc = '[P]review [H]unk' })
    map('n', '<leader>hi', gitsigns.preview_hunk_inline, { desc = '[P]review hunk [I]nline' })

    map('n', '<leader>hb', function()
      gitsigns.blame_line({ full = true })
    end, { desc = '[B]lame [L]ine' })

    map('n', '<leader>hd', gitsigns.diffthis, { desc = 'Git [D]iff' })

    map('n', '<leader>hD', function()
      gitsigns.diffthis('~')
    end, { desc = 'Git [D]iff HEAD~' })

    map('n', '<leader>hQ', function()
      gitsigns.setqflist('all')
    end, { desc = 'All [H]unks set [Q]uickfix list' })
    map('n', '<leader>hq', gitsigns.setqflist, { desc = '[H]unk set [Q]uickfix list' })

    -- Toggles
    map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = '[T]oggle current line [B]lame' })
    map('n', '<leader>tw', gitsigns.toggle_word_diff, { desc = '[T]oggle [Word] diff' })

    -- Text object
    map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
  end,
})
