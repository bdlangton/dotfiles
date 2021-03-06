" This must be first because it changes other options as a side effect.
set nocompatible

" Need to set the leader before defining any leader mappings.
let mapleader = "\\"

" Set local leader (used for the Vim Plugin for Drupal).
let maplocalleader = ','

" Ensure that plug.vim is installed.
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  augroup PlugInstall
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
  augroup END
endif

" Matches more opening and closing functions/methods/etc with '%' than
" normally would be matched without this.
runtime macros/matchit.vim

" Source in vim functions.
if filereadable($HOME . '/.vimrc.functions')
  source ~/.vimrc.functions
endif

" Source in plugins.
function! s:SourceConfigFilesIn(directory)
  let directory_splat = '~/.vim/' . a:directory . '/*'
  for config_file in split(glob(directory_splat), '\n')
    if filereadable(config_file)
      execute 'source' config_file
    endif
  endfor
endfunction

call plug#begin('~/.vim/bundle')
call s:SourceConfigFilesIn('rcplugins')
call plug#end()

" Load project specific vimrc if it exists.
" Has to be after rcplugins and before rcfiles.
let g:projroot = projectroot#guess()
if g:projroot !=? '' && g:projroot !=? $HOME
  augroup ProjectRoot
    autocmd BufEnter * exec 'lcd ' . g:projroot
  augroup END
  if filereadable(g:projroot . '/.vimrc')
    let b:local_vimrc = g:projroot . '/.vimrc'
    exec 'source ' . b:local_vimrc
  endif
endif

call s:SourceConfigFilesIn('rcfiles')

" Local config.
if filereadable($HOME . '/.vimrc.local')
  source ~/.vimrc.local
endif
