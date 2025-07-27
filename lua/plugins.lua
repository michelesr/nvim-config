-- ---------------------------------------------------------------------------------------------
-- boostrap section: automatically install lazy.nvim package manager if not installed already --
-- ---------------------------------------------------------------------------------------------
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
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

  -- Git plugin (and :GB for github.com)
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',

  --  Vim syntax for Helm templates (yaml + gotmpl + sprig + custom)
  { 'towolf/vim-helm', lazy = true, ft = 'helm' },

  -- Ranger integration
  {
    'francoiscabrol/ranger.vim',
    lazy = true,
    cmd = { 'Ranger', 'RangerWorkingDirectory' },
    dependencies = {
      -- Close buffer without closing window
      'rbgrouleff/bclose.vim',
    },
  },

  -- Adds indentation text objects
  'michaeljsmith/vim-indent-object',

  -- FZF
  {
    'junegunn/fzf.vim',
    lazy = true,
    cmd = { 'Files', 'History', 'Commits', 'BCommits' },
    dependencies = { 'junegunn/fzf' },
  },

  -- --------------------------------------------------------------------------------------
  -- lua section: plugins installed here needs setup() to be called, you can use opts={} --
  -- shortcut to pass the config table, equivalent to require('plugin-name').setup()     --
  -- --------------------------------------------------------------------------------------

  -- Comment lines with gc<motion> or a line with gcc
  { 'numToStr/Comment.nvim', opts = {} },

  -- Similar to tpope/vim-surround
  { 'kylechui/nvim-surround', opts = {} },

  -- To install extensions such as language servers
  {
    'williamboman/mason.nvim',
    dependencies = {
      -- Quickstart configs for Nvim LSP
      'neovim/nvim-lspconfig',
    },
    opts = {},
  },

  -- Standalone UI for nvim-lsp progress
  { 'j-hui/fidget.nvim', opts = {} },

  -- Completion engine and extensions
  {
    'saghen/blink.cmp',
    -- optional: provides snippets for the snippet source
    dependencies = { 'rafamadriz/friendly-snippets' },

    -- use a release tag to download pre-built binaries
    version = '1.*',
    -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
    -- build = 'cargo build --release',
    -- If you use nix, you can build from source using latest nightly rust with:
    -- build = 'nix run .#build-plugin',

    opts = require('config.blink'),
    opts_extend = { 'sources.default' },
  },

  -- Required by telescope
  {
    'nvim-telescope/telescope.nvim',
    lazy = true,
    cmd = 'Telescope',
    config = function()
      require('config.telescope')
    end,
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    },
  },

  -- Tresitter
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    build = ':TSUpdate',
    dependencies = {
      { 'nvim-treesitter/nvim-treesitter-textobjects', branch = 'main' },
    },
    config = function()
      require('config.treesitter')
    end,
  },

  -- Tresitter playground
  { 'nvim-treesitter/playground', lazy = true, cmd = 'TSPlaygroundToggle' },

  -- Colorscheme
  {
    'navarasu/onedark.nvim',
    config = function()
      require('config.onedark')
    end,
  },

  -- Status line
  { 'nvim-lualine/lualine.nvim', opts = require('config.lualine') },

  -- Icons
  { 'nvim-tree/nvim-web-devicons', lazy = true, opts = {} },

  -- Faster LuaLS setup for Neovim
  { 'folke/lazydev.nvim', ft = 'lua', opts = {} },

  -- REPL for lua and vimscript
  { 'ii14/neorepl.nvim', lazy = true, cmd = 'Repl' },

  -- Disable some features on big files for perfomance (e.g. LSP, Treesitter)
  { 'ouuan/nvim-bigfile', opts = {
    hook = function()
      vim.cmd(':NoMatchParen')
    end,
  } },

  -- Git integration for buffers
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('config.gitsigns')
    end,
  },

  { 'windwp/nvim-autopairs', event = 'InsertEnter', opts = {} },
}, {
  performance = {
    rtp = {
      -- keep original entries of runtimepath, for vim files installed by the system package manager
      reset = false,
    },
  },
})
