local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')
local telescope = require('telescope')

local function fugitive_open(prompt_bufnr)
  -- close the telescope window
  actions.close(prompt_bufnr)

  -- get the hash of the commit
  local sha = action_state.get_selected_entry().value

  -- open the commit in fugitive
  vim.cmd(string.format("execute 'e' FugitiveFind('%s')", sha))
end

local git_mappings = {
  ['<CR>'] = fugitive_open,
  ['<C-c>'] = actions.git_checkout,
}
git_mappings = { i = git_mappings, n = git_mappings }

telescope.setup({
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
      mappings = git_mappings,
    },
    git_bcommits = {
      mappings = git_mappings,
    },
  },
})

telescope.load_extension('fzf')
