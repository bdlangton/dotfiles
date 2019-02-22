" Ensure that plug.vim is installed.
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Matches more opening and closing functions/methods/etc with '%' than
" normally would be matched without this.
runtime macros/matchit.vim

" Source in vim functions.
if filereadable($HOME . "/.vimrc.functions")
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

call s:SourceConfigFilesIn('rcfiles')

" Local config.
if filereadable($HOME . "/.vimrc.local")
  source ~/.vimrc.local
endif
