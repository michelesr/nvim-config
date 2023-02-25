-- ---------------------------------------------------------------------------------------------
-- boostrap section: automatically install lazy.nvim package manager if not installed already --
-- ---------------------------------------------------------------------------------------------
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'folke/lazy.nvim.git',
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
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',

  --  Vim syntax for Helm templates (yaml + gotmpl + sprig + custom)
  'towolf/vim-helm',

  -- Close buffer without closing window (required by Ranger)
  'rbgrouleff/bclose.vim',

  -- Ranger integration
  'francoiscabrol/ranger.vim',

  -- Adds indentation text objects
  'michaeljsmith/vim-indent-object',

  -- FZF
  'junegunn/fzf',
  'junegunn/fzf.vim',

  -- --------------------------------------------------------------------------------------
  -- lua section: plugins installed here needs setup() to be called, you can use opts={} --
  -- shortcut to pass the config table, equivalent to require('plugin-name').setup()     --
  -- --------------------------------------------------------------------------------------

  -- Comment lines with gc<motion> or a line with gcc
  { 'numToStr/Comment.nvim', opts = {} },

  -- Similar to tpope/vim-surround
  { 'kylechui/nvim-surround', opts = {} },

  -- LSP base config
  'neovim/nvim-lspconfig',

  -- To install extensions such as language servers
  'williamboman/mason.nvim',
  'williamboman/mason-lspconfig.nvim',

  -- Standalone UI for nvim-lsp progress
  { 'j-hui/fidget.nvim', opts = {} },

  -- Completion engine and extensions
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-buffer',
  'hrsh7th/cmp-path',
  'hrsh7th/cmp-cmdline',
  'hrsh7th/nvim-cmp',
  'hrsh7th/cmp-vsnip',
  'hrsh7th/vim-vsnip',

  -- Required by telescope
  'nvim-lua/plenary.nvim',
  'nvim-telescope/telescope.nvim',
  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },

  -- Tresitter
  { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
  'nvim-treesitter/playground',
  'nvim-treesitter/nvim-treesitter-textobjects',

  -- Colorscheme
  'navarasu/onedark.nvim',

  -- Status line
  'nvim-lualine/lualine.nvim',

  -- Neovim setup for init.lua and plugin development with full signature help,
  -- docs and completion for the nvim lua API.
  { 'folke/neodev.nvim', opts = {} },

  -- REPL for lua and vimscript
  'ii14/neorepl.nvim',
})
