" =============================================================================
" General VIM Configuration

" Ensure that plug.vim is installed.
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
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

" Matches more opening and closing functions/methods/etc with '%' than
" normally would be matched without this.
runtime macros/matchit.vim

" Suppress errors with python3.
" This is due to a known vim/py3 issue:
" https://github.com/vim/vim/issues/3117#issuecomment-402622616
if has('python3')
  silent! python3 1
endif

" Leader is comma.
let mapleader=","

" Set the zsh shell (aliases need to be in ~/.zshenv).
if has('zsh')
  set shell=zsh\ -l
end

set nocompatible

" Allow backspace to work like in most programs.
set backspace=indent,eol,start

" Set swap file to go in a tmp directory.
set swapfile
set backupdir=~/.vim/tmp
set directory=~/.vim/tmp

" Tabs converted to spaces.
set expandtab

" Tab key produces 2 spaces.
set tabstop=2

" Number of spaces in tab when editing.
set softtabstop=2

" Set shift width.
set shiftwidth=2

" Load filetype-specific indent files.
filetype indent on

" Auto chdir into the directory of the current file.
autocmd BufEnter * silent! lcd %:p:h

" Automatically rebalance windows on vim resize.
autocmd VimResized * :wincmd =

" =============================================================================
" Custom Functions

" Save the cwd to a variable so it can be retrieved at a later time.
function! SaveDir()
  let w:saved_dir = getcwd()
endfunction

" Restore the directory that was last saved with SaveDir().
function! RestoreDir()
  if exists("w:saved_dir")
    :cd `=w:saved_dir`
  endif
endfunction

" Change directory to docroot if possible.
" This is just for D8 sites where the current dir might be above docroot and
" we need to be in docroot for drush/drupal console.
function! CdDocroot()
  if isdirectory('docroot')
    cd docroot
  endif
endfunction

" Prompt for a directory to CD into.
function! PromptDir()
  let root = getcwd()
  call inputsave()
  let input = input('Search dir: ' . root . '/')
  call inputrestore()
  if (isdirectory(root . '/' . input))
    exe 'cd ' . root . '/' . input
  endif
endfunction

function! GetBufferList()
  redir =>buflist
  silent! ls!
  redir END
  return buflist
endfunction

function! ToggleList(bufname, pfx)
  let buflist = GetBufferList()
  for bufnum in map(filter(split(buflist, '\n'), 'v:val =~ "'.a:bufname.'"'), 'str2nr(matchstr(v:val, "\\d\\+"))')
    if bufwinnr(bufnum) != -1
      exec(a:pfx.'close')
      return
    endif
  endfor
  if a:pfx == 'l' && len(getloclist(0)) == 0
      echohl ErrorMsg
      echo "Location List is Empty."
      return
  endif
  let winnr = winnr()
  exec(a:pfx.'open')
  if winnr() != winnr
    wincmd p
  endif
endfunction

" =============================================================================
" Usability Improvements

" When you start searching text with /, search is performed at every new
" character insertion.
set nopaste
set autoindent
set fileformats=unix,dos

" Docblock comments are continued when a newline is inserted.
set comments=sr:/*,mb:*,ex:*/
filetype on
filetype plugin on

" Toggle things on window leave/enter to make which window is active more
" obvious.
augroup BgHighlight
  autocmd!
  autocmd WinEnter * set colorcolumn=81
  autocmd WinEnter * set cul
  autocmd WinEnter * set relativenumber
  autocmd WinEnter * set number
  autocmd WinLeave * set colorcolumn=0
  autocmd WinLeave * set nocul
  autocmd WinLeave * set norelativenumber
  autocmd WinLeave * set nonumber
augroup END

" Automatically use the system clipboard for copy and paste.
"set clipboard=unnamed

" =============================================================================
" Drupal Functionality

" Drupal mappings.
nnoremap <Leader>dcc :call SaveDir()<CR>:call CdDocroot()<CR>:!drupal cc all<CR>:call RestoreDir()<CR>
nnoremap <Leader>dwd :call SaveDir()<CR>:call CdDocroot()<CR>:!drush watchdog-show<CR>:call RestoreDir()<CR>
nnoremap <Leader>dce :call SaveDir()<CR>:call CdDocroot()<CR>:!drupal config:export<CR>:call RestoreDir()<CR>
nnoremap <Leader>dci :call SaveDir()<CR>:call CdDocroot()<CR>:!drupal config:import<CR>:call RestoreDir()<CR>
nnoremap <Leader>dmi :call SaveDir()<CR>:call CdDocroot()<CR>:call DrupalSingleInput('module:install', 'Enter module to install: ')<CR>:call RestoreDir()<CR>
nnoremap <Leader>dmu :call SaveDir()<CR>:call CdDocroot()<CR>:call DrupalSingleInput('module:uninstall', 'Enter module to uninstall: ')<CR>:call RestoreDir()<CR>

" Prompt for a module to install.
function! DrupalSingleInput(command, text)
  call inputsave()
  let input = input(a:text)
  call inputrestore()
  execute '!drupal ' a:command input
endfunction

" =============================================================================
" Custom Mappings

" Escape using jk.
inoremap jk <esc>

" Use <C-Z> to clear the highlighting of :set hlsearch.
if maparg('<C-L>', 'n') ==# ''
  nnoremap <silent> <C-Z> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
endif

" Check syntax with Ctrl + \.
autocmd FileType php noremap <C-\> :!/usr/bin/env php -l %<CR>
autocmd FileType phtml noremap <C-\> :!/usr/bin/env php -l %<CR>

" Add line without entering insert mode.
nmap <S-Enter> O<Esc>
nmap <CR> o<Esc>

" Disable the arrow keys.
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

" Open the file explorer in current working directory split vert or horiz.
nmap <Leader>- :sp.<CR>
nmap <Leader>\ :vs.<CR>

" Toggle the location and quickfix windows.
nnoremap <silent> <leader>cl :call ToggleList("Location List", 'l')<CR>
nnoremap <silent> <leader>ce :call ToggleList("Quickfix List", 'c')<CR>

" FZF mappings.
nmap <Leader>b :Buffers<CR>
nmap <expr> <Leader>f ':Files ' . projectroot#guess() . '/<CR>'
nmap <Leader>F :Files ~/<C-r>=join(split(getcwd(), "/")[2:], "/")<CR>
nmap <Leader>g :Commits<CR>
nmap <Leader>l :BLines<CR>
nmap <Leader>L :Lines<CR>
nmap <Leader>t :BTags<CR>
nmap <Leader>T :Tags<CR>
nmap <Leader>a :call SaveDir()<CR>:ProjectRootCD<CR>:Ag<CR>:call RestoreDir()<CR>
nmap <Leader>A :call PromptDir()<CR>:Ag<CR>

" Neovim specific.
if has('nvim')
  tnoremap <Esc> <C-\><C-n>
endif

" Close buffers.
nnoremap <silent> Q :CloseBuffersMenu<CR>

" Zoom a vim pane (<leader>+), <leader>= to re-balance.
nnoremap <leader>+ :wincmd _<cr>:wincmd \|<cr>
nnoremap <leader>= :wincmd =<cr>

" Swap windows like tmux.
nmap <leader>{ <C-w>x
nmap <leader>} <C-w>x

" Close current window like tmux.
nmap <leader>x :hide<CR>

" =============================================================================
" Miscellaneous

" Local config.
if filereadable($HOME . "/.vimrc.local")
  source ~/.vimrc.local
endif
