" Automatic line wraps.
setlocal textwidth=100

" Set a line at column where text will wrap.
setlocal colorcolumn=101

" Toggle things on window leave/enter to make which window is active more
" obvious.
augroup FtBgHighlight
  autocmd!
  autocmd WinEnter * set colorcolumn=101
  autocmd WinLeave * set colorcolumn=0
augroup END

" Ale linters and fixers.
let b:ale_linters = ['eslint', 'prettier']
