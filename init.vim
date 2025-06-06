" general options
set number relativenumber mouse=a inccommand=split signcolumn=auto

" tab should always be visualized as 8 spaces to avoid problems when a mix of
" tab and spaces are used for vertical alignment in languages that prefer
" tabs; as a general rule expand tab with 2 spaces
set shiftwidth=2 tabstop=8 softtabstop=0 expandtab smarttab

let g:ranger_map_keys = 0
let g:bclose_no_plugin_maps = 1

" stop highlighting old search results
nnoremap <leader><leader> :nohlsearch<CR>

" fuzzy finding
nnoremap <leader>f :Telescope find_files<CR>
nnoremap <leader>b :Telescope buffers<CR>
nnoremap <leader>h :Telescope oldfiles<CR>
nnoremap <leader>g :Telescope live_grep<CR>
nnoremap <leader>G :Telescope grep_string<CR>
nnoremap <leader>/ :Telescope search_history<CR>
nnoremap <leader>: :Telescope commands<CR>
nnoremap <leader>c :Commits<CR>
nnoremap <leader>C :BCommits<CR>

" telescope
nnoremap <leader>s :Telescope<CR>

" open ranger file manager
nnoremap <leader>r :Ranger<CR>
nnoremap <leader>R :RangerWorkingDirectory<CR>

" open file explorer
nnoremap <leader>o :edit %:h<CR>
nnoremap <leader>O :edit .<CR>

" toggle relative number
nnoremap <leader>n :set relativenumber!<CR>

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
cnoreabbrev gs Gitsigns
cnoreabbrev ghs Gitsigns stage_hunk
cnoreabbrev ghu Gitsigns undo_stage_hunk
cnoreabbrev gd Gdiffsplit
cnoreabbrev gvd Gvdiffsplit
cnoreabbrev ghd Ghdiffsplit
cnoreabbrev vr vertical resize
cnoreabbrev hr horizontal resize

luafile ~/.config/nvim/lua/init.lua
