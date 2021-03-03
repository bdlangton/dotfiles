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

" Ale linters.
let b:ale_linter_aliases = ['css', 'javascript']
let b:ale_linters = ['stylelint', 'eslint']
