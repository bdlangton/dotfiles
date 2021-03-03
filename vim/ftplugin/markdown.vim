" Enable spellchecking.
setlocal spell

" Automatic line wraps.
setlocal textwidth=80

" Set a line at column where text will wrap.
setlocal colorcolumn=81

" Toggle things on window leave/enter to make which window is active more
" obvious.
augroup FtBgHighlight
  autocmd!
  autocmd WinEnter * set colorcolumn=81
  autocmd WinLeave * set colorcolumn=0
augroup END

" Linting with remark.
let b:ale_linters = ['remark-lint']
