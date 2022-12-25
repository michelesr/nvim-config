return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'https://github.com/wbthomason/packer.nvim'

  -- Git plugin
  use 'https://github.com/tpope/vim-fugitive'
  -- GitHub support (e.g. GBrowse)
  use 'https://github.com/tpope/vim-rhubarb'

  -- Comment lines with gc<motion> or a line with gcc
  use 'https://github.com/tpope/vim-commentary'

  -- Ranger integration
  use 'https://github.com/francoiscabrol/ranger.vim'
  -- Close buffer without closing window (required by Ranger)
  use 'https://github.com/rbgrouleff/bclose.vim'

  -- LSP base config
  use 'https://github.com/neovim/nvim-lspconfig'

  -- To install extensions such as language servers
  use 'https://github.com/williamboman/mason.nvim'
  use 'https://github.com/williamboman/mason-lspconfig.nvim'

  -- Completion engine and extensions
  use 'https://github.com/hrsh7th/cmp-nvim-lsp'
  use 'https://github.com/hrsh7th/cmp-buffer'
  use 'https://github.com/hrsh7th/cmp-path'
  use 'https://github.com/hrsh7th/cmp-cmdline'
  use 'https://github.com/hrsh7th/nvim-cmp'
  use 'https://github.com/hrsh7th/cmp-vsnip'
  use 'https://github.com/hrsh7th/vim-vsnip'

  -- Required by telescope
  use 'https://github.com/nvim-lua/plenary.nvim'
  use 'https://github.com/nvim-telescope/telescope.nvim'
  use {'https://github.com/nvim-telescope/telescope-fzf-native.nvim', run = 'make' }

  -- Tresitter
  use {'https://github.com/nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
  use 'https://github.com/nvim-treesitter/playground'
  use 'nvim-treesitter/nvim-treesitter-textobjects'

  -- Adds indentation text objects
  use 'https://github.com/michaeljsmith/vim-indent-object'

  -- FZF
  use 'https://github.com/junegunn/fzf'
  use 'https://github.com/junegunn/fzf.vim'

  -- Colorscheme
  use 'https://github.com/navarasu/onedark.nvim'

  -- Status line
  use 'https://github.com/nvim-lualine/lualine.nvim'

  -- REPL for lua and vimscript
  use 'https://github.com/ii14/neorepl.nvim'

  -- Helm templates filetype plugin
  use 'https://github.com/towolf/vim-helm'
end)
