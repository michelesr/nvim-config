" general options
set number autoindent cindent ruler showcmd history=10000
set showmode mouse=a laststatus=2 incsearch inccommand=split
set wildmenu hlsearch listchars=eol:$ signcolumn=number

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
nnoremap <leader>f :Files<CR>
nnoremap <leader>h :History<CR>
nnoremap <leader>c :Commits<CR>
nnoremap <leader>t :Tags<CR>

" telescope
nnoremap <leader>s :Telescope<CR>

" open ranger file manager
nnoremap <leader>r :Ranger<CR>

" prepare command prompt for an ack search
nnoremap <leader>a :Ack<Space>

" this will bring terminal buffer in normal mode
tnoremap <C-j>j <C-\><C-n>
tnoremap <C-j><C-j> <C-\><C-n>

" remove trailing spaces and tabs on saving
augroup UserWritePre
  autocmd!
  autocmd BufWritePre * :%s/\s\+$//ec
augroup END

augroup HelmTemplates
  autocmd!
  " disables treesitter highlight and diagnostics if it's an helm template
  autocmd FileType yaml :lua require('scripts.helm-template-quirks').run()
augroup END

" specific file type options
augroup UserFileType
  autocmd!
  " golang convention (e.g gofmt) want hard tabs
  autocmd FileType go setlocal sw=8 noet
  " linux kernel development convention
  autocmd FileType c setlocal sw=8 noet
  " make requires hard tabs
  autocmd FileType make setlocal sw=8 noet
  autocmd FileType markdown setlocal spell
augroup END

augroup Term
  autocmd!
  " do not show line number on terminal windows
  autocmd TermOpen * setlocal nonumber norelativenumber
augroup END

function Tmux(cmd)
  " create a terminal buffer with tmux
  exe "te" "tmux new-session " . a:cmd . "\\; set status off"

  " rename it to simply tmux
  exe "f" substitute(bufname(), "tmux.*", "tmux", "")
endfunction

" run tmux in a terminal window
command -nargs=? T :call Tmux("<args>")

" command to autoreload LSP server settings
command -nargs=0 LspConfigReload :luafile ~/.config/nvim/lua/config/lsp-servers.lua

" disable ranger mappings
let g:ranger_map_keys = 0

" disable bclose mappings
let g:bclose_no_plugin_maps = 1

" use https://github.com/ggreer/the_silver_searcher for :Ack
let g:ackprg = 'ag --vimgrep'

" source lua config
luafile ~/.config/nvim/lua/init.lua
