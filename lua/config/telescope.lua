-- telescope-fzf-native.nvim
-- You dont need to set any of these options. These are the default ones. Only
-- the loading is important
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')

actions.fugitive_open = function(buffer)
  -- close the telescope window
  actions.close(buffer)

  -- get the hash of the commit
  local sha = action_state.get_selected_entry().value

  -- open the commit in fugitive
  vim.cmd(string.format("execute 'e' FugitiveFind('%s')", sha))
end

require('telescope').setup({
  extensions = {
    fzf = {
      fuzzy = true, -- false will only do exact matching
      override_generic_sorter = true, -- override the generic sorter
      override_file_sorter = true, -- override the file sorter
      case_mode = 'smart_case', -- or 'ignore_case' or 'respect_case'
      -- the default case_mode is 'smart_case'
    },
  },
  defaults = {
    mappings = {
      i = {
        ['<C-k>'] = actions.move_selection_previous,
        ['<C-j>'] = actions.move_selection_next,
      },
    },
  },
  pickers = {
    git_commits = {
      mappings = {
        i = {
          ['<CR>'] = actions.fugitive_open,
          ['<C-c>'] = actions.git_checkout,
        },
      },
    },
    git_bcommits = {
      mappings = {
        i = {
          ['<CR>'] = actions.fugitive_open,
          ['<C-c>'] = actions.git_checkout,
        },
      },
    },
  },
})
-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
require('telescope').load_extension('fzf')
