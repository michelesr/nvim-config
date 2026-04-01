-- see :help ui2
require('vim._core.ui2').enable({
  enable = true,
})

-- add :PackUpdate command to update packages
vim.api.nvim_create_user_command('PackUpdate', function()
  vim.pack.update()
end, {})

-- add :PackSync command to sync with the lockfile
vim.api.nvim_create_user_command('PackSync', function()
  vim.pack.update(nil, { target = 'lockfile' })
end, {})

local function add_build_hook(plugin_name, cmd_type, cmd)
  vim.api.nvim_create_autocmd('PackChanged', {
    callback = function(ev)
      local name, kind = ev.data.spec.name, ev.data.kind

      if name == plugin_name and (kind == 'install' or kind == 'update') then
        vim.notify(
          string.format(
            'Running build hook: {plugin_name = %s, event = %s, cmd_type = %s, cmd = %s}',
            vim.inspect(name),
            vim.inspect(kind),
            vim.inspect(cmd_type),
            vim.inspect(cmd)
          )
        )

        if not ev.data.active then
          vim.cmd.packadd(plugin_name)
        end

        if cmd_type == 'vim' then
          vim.cmd(cmd)
        elseif cmd_type == 'system' then
          vim.system(cmd, { cwd = ev.data.path }):wait()
        end
      end
    end,
  })
end

add_build_hook('nvim-treesitter', 'vim', 'TSUpdate')
add_build_hook('blink.cmp', 'system', { 'cargo', 'build', '--release' })
add_build_hook('telescope-fzf-native.nvim', 'system', { 'make' })

vim.pack.add({
  ------------------------------------------------------------------------------------------------
  -- vimscript section: plugins installed here are loaded automatically, no need to run setup() --
  ------------------------------------------------------------------------------------------------

  -- Git plugin (and :GB for github.com)
  'https://github.com/tpope/vim-fugitive',
  'https://github.com/tpope/vim-rhubarb',

  --  Vim syntax for Helm templates (yaml + gotmpl + sprig + custom)
  'https://github.com/towolf/vim-helm',

  -- Close buffer without closing window
  'https://github.com/rbgrouleff/bclose.vim',

  -- Ranger integration
  'https://github.com/francoiscabrol/ranger.vim',

  -- Adds indentation text objects
  'https://github.com/michaeljsmith/vim-indent-object',

  -- FZF
  'https://github.com/junegunn/fzf',
  'https://github.com/junegunn/fzf.vim',

  -- --------------------------------------------------------------------------------------
  -- lua section: plugins installed here needs setup() to be called for initialization
  -- --------------------------------------------------------------------------------------

  -- Comment lines with gc<motion> or a line with gcc
  'https://github.com/numToStr/Comment.nvim',

  -- Similar to tpope/vim-surround
  'https://github.com/kylechui/nvim-surround',

  -- To install extensions such as language servers
  'https://github.com/williamboman/mason.nvim',

  -- Quickstart configs for Nvim LSP
  'https://github.com/neovim/nvim-lspconfig',

  -- Standalone UI for nvim-lsp progress
  'https://github.com/j-hui/fidget.nvim',

  -- optional: provides snippets for the snippet source
  'https://github.com/rafamadriz/friendly-snippets',

  -- Completion engine and extensions
  'https://github.com/saghen/blink.cmp',

  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/nvim-telescope/telescope.nvim',

  'https://github.com/nvim-telescope/telescope-fzf-native.nvim',

  -- Tresitter
  'https://github.com/nvim-treesitter/nvim-treesitter',
  'https://github.com/nvim-treesitter/nvim-treesitter-textobjects',

  -- Colorscheme
  'https://github.com/navarasu/onedark.nvim',

  -- Status line
  'https://github.com/nvim-lualine/lualine.nvim',

  -- Faster LuaLS setup for Neovim
  'https://github.com/folke/lazydev.nvim',

  -- Disable some features on big files for perfomance (e.g. LSP, Treesitter)
  'https://github.com/ouuan/nvim-bigfile',

  -- Git integration for buffers
  'https://github.com/lewis6991/gitsigns.nvim',

  -- Automatically close pairs like quotes or brackets
  'https://github.com/windwp/nvim-autopairs',
})

require('Comment').setup()
require('nvim-surround').setup()
require('mason').setup()
require('fidget').setup({})

require('blink.cmp').setup(require('config.blink'))

require('telescope').setup(require('config.telescope'))
require('telescope').load_extension('fzf')

require('config.treesitter')

require('onedark').setup(require('config.onedark'))
require('onedark').load()
require('lualine').setup(require('config.lualine'))
require('lazydev').setup()

require('bigfile').setup({
  hook = function()
    vim.cmd(':NoMatchParen')
  end,
})

require('gitsigns').setup(require('config.gitsigns'))
require('nvim-autopairs')
require('config.lsp')
require('scripts.tmux')

-- explicit file type detection for helm templates
vim.filetype.add({
  pattern = {
    ['.*/templates/.*%.yaml'] = 'helm',
    ['.*/templates/.*%.yml'] = 'helm',
    ['.*/templates/.*%.tpl'] = 'helm',
  },
})
