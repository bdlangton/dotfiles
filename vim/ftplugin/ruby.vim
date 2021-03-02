" Automatic line wraps.
setlocal textwidth=100

" Set a line at column where text will wrap.
setlocal colorcolumn=101

" Ale configuration values.
let g:ale_ruby_rubocop_options = '--config $HOME/.config/rubocop/config.yml'

" Ale linters and fixer.
let b:ale_linters = ['rubocop']
" let b:ale_fixers = ['rubocop']
