" Ale linters.
" Can't do prettier as an ale fixer, because on save it will fix the errors
" but also print out a list of all files in the current directory. This is
" because of my function that does an 'ls' after a 'cd'. I'm not sure why
" prettier does a 'cd'.
let b:ale_linters = ['eslint', 'prettier']
