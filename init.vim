" install plugins in bundle folder
call plug#begin('~/.config/nvim/bundle')
  " Git plugin
  Plug 'tpope/vim-fugitive'
  " GitHub support (e.g. GBrowse)
  Plug 'tpope/vim-rhubarb'

  " Ranger integration
  Plug 'francoiscabrol/ranger.vim'
  " Close buffer without closing window (required by Ranger)
  Plug 'rbgrouleff/bclose.vim'

  " LSP base config
  Plug 'neovim/nvim-lspconfig'

  " To install LSP servers easily with :LspInstall
  Plug 'williamboman/nvim-lsp-installer'

  " Completion engine and extensions
  Plug 'hrsh7th/cmp-nvim-lsp'
  Plug 'hrsh7th/cmp-buffer'
  Plug 'hrsh7th/cmp-path'
  Plug 'hrsh7th/cmp-cmdline'
  Plug 'hrsh7th/nvim-cmp'
  Plug 'hrsh7th/cmp-vsnip'
  Plug 'hrsh7th/vim-vsnip'

  " Show a lightbulb when a codeaction is available
  Plug 'kosayoda/nvim-lightbulb'
  Plug 'antoinemadec/FixCursorHold.nvim'

  " Required by telescope
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim'
  Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }

  " Tresitter
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  Plug 'SmiteshP/nvim-gps'

  " FZF
  Plug 'junegunn/fzf'
  Plug 'junegunn/fzf.vim'

  " Colorscheme
  Plug 'navarasu/onedark.nvim'

  " Like :grep but better
  Plug 'mileszs/ack.vim'

  " Status line
  Plug 'nvim-lualine/lualine.nvim'
call plug#end()

" syntax and indentation
syntax on
filetype plugin indent on

" general options
set number autoindent cindent ruler showcmd history=10000
set showmode mouse=a laststatus=2 incsearch inccommand=split
set wildmenu hlsearch listchars=eol:$ signcolumn=number

" avoid unnecessary redraws
set nocursorline norelativenumber lazyredraw

" tab should always be visualized as 8 spaces to avoid problems when a mix of
" tab and spaces are used for vertical alignment in languages that prefer
" tabs; as a general rule expand tab with 2 spaces
set shiftwidth=2 tabstop=8 softtabstop=0 expandtab

" folding is a feature to reduce and expand code blocks
set foldmethod=indent foldlevelstart=10 foldnestmax=10

" stop highlighting old search results
nnoremap <leader><space> :nohlsearch<CR>

" open current buffer in new tab
noremap tt :tab split<CR>

" fzf
nnoremap <leader>f :FZF<CR>
nnoremap <leader>h :History<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>c :Commits<CR>
nnoremap <leader>C :BCommits<CR>
nnoremap <leader>l :Lines<CR>
nnoremap <leader>L :BLines<CR>
nnoremap <leader>t :Tags<CR>
nnoremap <leader>T :BTags<CR>
nnoremap <leader>m :Marks<CR>
nnoremap <leader>w :Windows<CR>

" telescope
nnoremap <leader>s :Telescope<CR>
nnoremap <space>f :Telescope find_files<CR>
nnoremap <space>s :Telescope lsp_dynamic_workspace_symbols<CR>
nnoremap <space>o :Telescope lsp_document_symbols<CR>
nnoremap <space>r :Telescope lsp_references<CR>

" open ranger file manager
nnoremap <leader>r :Ranger<CR>

" prepare command prompt for an ack search
nnoremap <leader>a :Ack<Space>

" this will bring terminal buffer in normal mode
tnoremap <C-j>j <C-\><C-n>
tnoremap <C-j><C-j> <C-\><C-n>

" remove trailing spaces and tabs on saving
autocmd BufWritePre * :%s/\s\+$//ec

" specific file extension options
augroup UserExtension
  autocmd BufNewFile,BufRead Thorfile\|*.thor setlocal filetype=ruby
augroup end

" specific file type options
augroup UserFileType
  autocmd FileType python setlocal sw=4 kp=:Run\ pydoc
  " https://github.com/rubocop-hq/ruby-style-guide#indentation
  autocmd FileType ruby setlocal kp=:TRun\ ri\ --no-pager
  " golang convention (e.g gofmt) want hard tabs
  autocmd FileType go setlocal sw=8 noet
  " linux kernel development convention
  autocmd FileType c setlocal sw=8 noet
  " make requires hard tabs
  autocmd FileType make setlocal sw=8 noet
  autocmd FileType markdown setlocal spell
augroup end

" do not show line number on terminal windows
autocmd TermOpen * setlocal nonumber norelativenumber

let g:ranger_map_keys = 0

" run commands and display output in the preview window
function RunCmd(cmd)
  silent exe "pedit " . a:cmd
  wincmd P
  set buftype=nofile
  exe "r! " . a:cmd
  1d
endfunction

" run command inside a terminal
function TermRunCmd(cmd)
  silent exe "sp term://" . a:cmd
endfunction

function Tmux(cmd)
  " create a terminal buffer with tmux
  exe "te" "tmux new-session " . a:cmd . "\\; set status off"

  " rename it to simply tmux
  exe "f" substitute(bufname(), "tmux.*", "tmux", "")
endfunction

" export RunCmd as :Run command
command -nargs=1 Run :call RunCmd("<args>")
command -nargs=1 TRun :call TermRunCmd("<args>")

" run tmux in a terminal window
command -nargs=? T :call Tmux("<args>")

" command to autoreload LSP server settings
command -nargs=0 LspConfigReload :luafile ~/.config/nvim/lua/lsp-servers-config.lua

" use ag with the Ack plugin
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

set termguicolors

" make cursor hold update quicker
let g:cursorhold_updatetime = 100

" source lua config
luafile ~/.config/nvim/lua/init.lua
