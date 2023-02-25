-- ---------------------------------------------------------------------------------------------
-- boostrap section: automatically install lazy.nvim package manager if not installed already --
-- ---------------------------------------------------------------------------------------------
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  ------------------------------------------------------------------------------------------------
  -- vimscript section: plugins installed here are loaded automatically, no need to run setup() --
  ------------------------------------------------------------------------------------------------

  -- Git plugin (and :GBrowse for github.com)
  'https://github.com/tpope/vim-fugitive',
  'https://github.com/tpope/vim-rhubarb',

  --  Vim syntax for Helm templates (yaml + gotmpl + sprig + custom)
  'https://github.com/towolf/vim-helm',

  -- Close buffer without closing window (required by Ranger)
  'https://github.com/rbgrouleff/bclose.vim',

  -- Ranger integration
  'https://github.com/francoiscabrol/ranger.vim',

  -- Adds indentation text objects
  'https://github.com/michaeljsmith/vim-indent-object',

  -- FZF
  'https://github.com/junegunn/fzf',
  'https://github.com/junegunn/fzf.vim',

  -- --------------------------------------------------------------------------------------
  -- lua section: plugins installed here needs setup() to be called, you can use opts={} --
  -- shortcut to pass the config table, equivalent to require('plugin-name').setup()     --
  -- --------------------------------------------------------------------------------------

  -- Comment lines with gc<motion> or a line with gcc
  { 'https://github.com/numToStr/Comment.nvim', opts = {} },

  -- Similar to https://github.com/tpope/vim-surround
  { 'https://github.com/kylechui/nvim-surround', opts = {} },

  -- LSP base config
  'https://github.com/neovim/nvim-lspconfig',

  -- To install extensions such as language servers
  'https://github.com/williamboman/mason.nvim',
  'https://github.com/williamboman/mason-lspconfig.nvim',

  -- Standalone UI for nvim-lsp progress
  { 'https://github.com/j-hui/fidget.nvim', opts = {} },

  -- Completion engine and extensions
  'https://github.com/hrsh7th/cmp-nvim-lsp',
  'https://github.com/hrsh7th/cmp-buffer',
  'https://github.com/hrsh7th/cmp-path',
  'https://github.com/hrsh7th/cmp-cmdline',
  'https://github.com/hrsh7th/nvim-cmp',
  'https://github.com/hrsh7th/cmp-vsnip',
  'https://github.com/hrsh7th/vim-vsnip',

  -- Required by telescope
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/nvim-telescope/telescope.nvim',
  { 'https://github.com/nvim-telescope/telescope-fzf-native.nvim', build = 'make' },

  -- Tresitter
  { 'https://github.com/nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
  'https://github.com/nvim-treesitter/playground',
  'nvim-treesitter/nvim-treesitter-textobjects',

  -- Colorscheme
  'https://github.com/navarasu/onedark.nvim',

  -- Status line
  'https://github.com/nvim-lualine/lualine.nvim',

  -- Neovim setup for init.lua and plugin development with full signature help,
  -- docs and completion for the nvim lua API.
  { 'https://github.com/folke/neodev.nvim', opts = {} },

  -- REPL for lua and vimscript
  'https://github.com/ii14/neorepl.nvim',
})
