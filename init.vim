" general options
set number mouse=a inccommand=split signcolumn=number

" tab should always be visualized as 8 spaces to avoid problems when a mix of
" tab and spaces are used for vertical alignment in languages that prefer
" tabs; as a general rule expand tab with 2 spaces
set shiftwidth=2 tabstop=8 softtabstop=0 expandtab smarttab

let g:ranger_map_keys = 0
let g:bclose_no_plugin_maps = 1

" stop highlighting old search results
nnoremap <leader><leader> :nohlsearch<CR>

" fzf
nnoremap <leader>f :Files<CR>
nnoremap <leader>h :History<CR>
nnoremap <leader>c :Commits<CR>
nnoremap <leader>t :Tags<CR>

" telescope
nnoremap <leader>s :Telescope<CR>

" open ranger file manager
nnoremap <leader>r :Ranger<CR>

" this will bring terminal buffer in normal mode
tnoremap <A-j><A-j> <C-\><C-n>

" specific file type options
augroup UserFileType
  autocmd!
  " golang convention (e.g gofmt) want hard tabs
  autocmd FileType go setlocal sw=8 noet
  " linux kernel development convention
  autocmd FileType c setlocal sw=8 noet
  " make requires hard tabs
  autocmd FileType make setlocal sw=8 noet
augroup END

augroup HelmFiletypeDetect
  autocmd!
  autocmd BufRead,BufNewFile */templates/*.yaml,*/templates/*.yml set ft=helm
augroup END

augroup UserTerm
  autocmd!
  " do not show line number on terminal windows
  autocmd TermOpen * setlocal nonumber norelativenumber
augroup END

" run tmux in a terminal window
function! Tmux(cmd)
  exe 'te' 'tmux new-session ' . a:cmd . '\; set status off'
  exe 'f' substitute(bufname(), 'tmux.*', 'tmux', '')
endfunction
command! -nargs=? T :call Tmux('<args>')

set grepprg=rg\ --vimgrep
command! -nargs=+ Grep silent grep! <args> | copen

cnoreabbrev Ag Rg
cnoreabbrev Ack Grep

luafile ~/.config/nvim/lua/init.lua
