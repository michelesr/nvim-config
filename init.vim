filetype off

" set the runtime path to include Vundle and initialize
set rtp+=~/.config/nvim/bundle/Vundle.vim

" install plugins in bundle folder
call vundle#begin('~/.config/nvim/bundle')
  " Vundle plugin manager
  Plugin 'VundleVim/Vundle.vim'

  " Git commands wrapper
  Plugin 'tpope/vim-fugitive'

  " Ranger integration
  Plugin 'francoiscabrol/ranger.vim'
  " Close buffer without closing window (required by Ranger)
  Plugin 'rbgrouleff/bclose.vim'

  " Autocompletion backend
  Plugin 'Shougo/deoplete.nvim'
  " Python Jedi
  Plugin 'deoplete-plugins/deoplete-jedi'
  " Collects keyword from ctags
  Plugin 'deoplete-plugins/deoplete-tag'

  " FZF
  Plugin 'junegunn/fzf'
  Plugin 'junegunn/fzf.vim'

  " Colorscheme
  Plugin 'joshdick/onedark.vim'

  " Like :grep but better
  Plugin 'mileszs/ack.vim'

  Plugin 'vim-airline/vim-airline'
  Plugin 'vim-airline/vim-airline-themes'
call vundle#end()
call deoplete#enable()

" syntax and indentation
syntax on
filetype plugin indent on

" general options
set number autoindent cindent ruler showcmd history=10000
set showmode mouse=a laststatus=2 incsearch inccommand=split
set wildmenu hlsearch listchars=eol:$

" avoid unnecessary redraws
set nocursorline norelativenumber lazyredraw

" tab should always be visualized as 8 spaces to avoid problems when a mix of
" tab and spaces are used for vertical alignment in languages that prefer
" tabs; as a general rule expand tab with 2 spaces
set shiftwidth=2 tabstop=8 softtabstop=0 expandtab

" folding is a feature to reduce and expand code blocks
set foldmethod=indent foldlevelstart=10 foldnestmax=10

" open/close code blocks with space
nnoremap <space> za

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

" open ranger file manager
nnoremap <leader>r :Ranger<CR>

" prepare command prompt for an ack search
nnoremap <leader>a :Ack<Space>

" this will bring terminal buffer in normal mode
tnoremap <C-j>j <C-\><C-n>
tnoremap <C-j><C-j> <C-\><C-n>

" remove trailing spaces and tabs on saving
autocmd BufWritePre * :%s/\s\+$//ec

" workaround to enforce exiting insert mode with alt
" even if completion popup is activated by deoplete
"   eg. inoremap <M-j> <Esc>j
for key in ["h", "j", "k", "l", "w", "e", "b", "0", "$", "x"]
  exe "inoremap <M-". key . "> <Esc>" . key
endfor

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

" close doc window (eg python jedi) when pressing ESC
autocmd InsertLeave * pclose

let g:deoplete#enable_at_startup = 1
let g:deoplete#sources#jedi#show_docstring = 1

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

" export RunCmd as :Run command
command -nargs=1 Run :call RunCmd("<args>")
command -nargs=1 TRun :call TermRunCmd("<args>")

" use ag with the Ack plugin
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

let g:onedark_color_overrides = {
\ "black": {"gui": "#1d1d2d", "cterm": "0", "cterm16": "0" },
\ "comment_grey": {"gui": "#6d7d7d", "cterm": "0", "cterm16": "0" },
\ "white": {"gui": "#bdcdcd", "cterm": "0", "cterm16": "0" },
\ "vertsplit": { "gui": "#8ffc67", "cterm": "0", "cterm16": "0" }
\}

set termguicolors
colorscheme onedark

" airline options
let g:airline_theme = 'onedark'
let g:airline_powerline_fonts = 1

" tabline options
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#show_splits = 0
let g:airline#extensions#tabline#show_tab_nr = 0
let g:airline#extensions#tabline#show_close_button = 0
let g:airline#extensions#tabline#buffer_min_count = 2
