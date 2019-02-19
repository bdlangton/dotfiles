if filereadable(expand("~/.vimrc.bundles"))
  source ~/.vimrc.bundles
endif

" =============================================================================
" General VIM Configuration

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

" Enable syntax processing.
syntax on

set nocompatible

" Allow backspace to work like in most programs.
set backspace=indent,eol,start

" Set swap file to go in a tmp directory.
set swapfile
set backupdir=~/.vim/tmp
set directory=~/.vim/tmp

" Set a line at column 81.
set colorcolumn=81

" Highlight current line.
set cursorline

" Show line numbers.
set number

" Show relative line numbers.
set relativenumber

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

" Visual autocomplete for command menu.
set wildmenu

" Highlight matching [{()}].
set showmatch

" Search as characters are entered.
set incsearch

" Highlight matches.
set hlsearch

" Show tabs as chars so it is visible.
set list
set listchars=tab:>-

" Auto chdir into the directory of the current file.
autocmd BufEnter * silent! lcd %:p:h

" Automatically rebalance windows on vim resize.
autocmd VimResized * :wincmd =

" Clear links for doxygen sections that were linked to Todo by
" vim-plugin-for-drupal.
hi link doxygenBrief NONE
hi link doxygenSpecialTypeOnelineDesc NONE

" =============================================================================
" Custom Functions

" Check if NERDTree is open or active.
function! IsNERDTreeOpen()
  return exists("t:NERDTreeBufName") && (bufwinnr(t:NERDTreeBufName) != -1)
endfunction

" Call NERDTreeFind if NERDTree is active, current window contains a modifiable
" file, we're not in vimdiff, and the current window isn't Tagbar.
function! SyncTree()
  if &modifiable && IsNERDTreeOpen() && strlen(expand('%')) > 0 && !&diff && bufname('%') !~ "Tagbar"
    NERDTreeFind
    wincmd p
  endif
endfunction

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
" Themes and Colors

" Set colorscheme.
set background=dark
set t_Co=256
if exists('+termguicolors')
  set termguicolors
endif
colorscheme solarized

" Modify colors for solarized.
hi clear SignColumn
hi ColorColumn ctermbg=0 guibg=Grey40
hi LineNr ctermfg=254 guifg=#e4e4e4
hi DiffAdd guifg=White guibg=DarkCyan
hi DiffChange guifg=White guibg=DarkYellow
hi DiffDelete guifg=Black guibg=#ffa0a0
hi default link GitGutterAdd DiffAdd
hi default link GitGutterChange DiffChange
hi default link GitGutterDelete DiffDelete
hi DbgBreakptSign guifg=Black guibg=Cyan
hi DbgBreakptLine guifg=Black guibg=Cyan
hi PMenu guibg=DarkBlue
hi PMenuSel guibg=Cyan
hi SpecialKey guifg=black guibg=red

" Set the lightline colorscheme.
source ~/.vimrc-solarizedcustom-lightline
let g:lightline = {
      \ 'colorscheme': 'solarizedcustom',
      \ 'component': {
      \   'modified': '%#ModifiedColor#%{LightlineModified()}',
      \ }
      \ }

function! LightlineModified()
  if &modified
    exe printf('hi ModifiedColor guifg=Black guibg=Yellow term=bold cterm=bold')
    return ' +'
  elseif &modifiable
    exe printf('hi ModifiedColor guifg=White guibg=#657b83 term=bold cterm=bold')
    return ''
  else
    exe printf('hi ModifiedColor guifg=White guibg=Magenta term=bold cterm=bold')
    return ' -'
  endif
endfunction

" Update status line for lightline plugin.
set laststatus=2

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

" Open the file explorer in current working directory: current window or split.
nmap <c-b> :e.<CR>
nmap <Leader>- :sp.<CR>
nmap <Leader>\ :vs.<CR>

" Toggle the display of tagbar.
noremap <c-t> :TagbarToggle<CR>

" Toggle the location and quickfix windows.
nmap <silent> <leader>l :call ToggleList("Location List", 'l')<CR>
nmap <silent> <leader>e :call ToggleList("Quickfix List", 'c')<CR>

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

" PDV mapping for docblock creation.
nnoremap <Leader>d :call pdv#DocumentWithSnip()<CR>

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
" Search

" For fzf fuzzy search.
set rtp+=/usr/local/opt/fzf

" FZF customization.
let $FZF_DEFAULT_COMMAND='ag --hidden --ignore ".git" --ignore "/tags" -g ""'

" FZF default options (use exact matches by default).
let $FZF_DEFAULT_OPTS='--exact'

" Use ag with ack.vim.
let g:ackprg = 'ag --vimgrep'

" =============================================================================
" Programming

" Vdebug options.
let g:vdebug_options= {
\    "port" : 9000,
\    "server" : '',
\    "timeout" : 20,
\    "on_close" : 'detach',
\    "break_on_open" : 0,
\    "ide_key" : '',
\    "path_maps" : {"/var/www/html": "/Users/barrett/fulcrum/sites"},
\    "debug_window_level" : 0,
\    "debug_file_level" : 0,
\    "debug_file" : "",
\    "watch_window_style" : 'compact',
\    "marker_default" : '⬦',
\    "marker_closed_tree" : '▸',
\    "marker_open_tree" : '▾',
\    'window_commands': {
\      'DebuggerWatch': 'vertical belowright new',
\      'DebuggerStack': 'belowright new +res5',
\      'DebuggerStatus': 'belowright new +res5'
\    }
\}

" Syntastic settings.
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 2
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_aggregate_errors = 1
let g:syntastic_php_checkers = ["php", "phpcs", "phpmd"]

" Set the codesniffer args.
let g:phpqa_codesniffer_args = "--standard=Drupal"

" PDV templates directory.
let g:pdv_template_dir = $HOME ."/.vim/bundle/pdv/templates_snip"

" Change vim-commentary to use `//` instead of `/* */`.
autocmd FileType php setlocal commentstring=//\ %s

" Disable auto folding.
let g:DisableAutoPHPFolding = 1

" Set tags file.
let g:autotagTagsFile="tags"

" =============================================================================
" NERDTree

" Use NERDTree in place of netrw (split explorer instead of project drawer).
let NERDTreeHijackNetrw=1

" Open NERD tree by default except when invoked by git.
" autocmd VimEnter * if &filetype !=# 'gitcommit' | NERDTree | endif
" autocmd VimEnter * wincmd p

" Set NERD Tree width.
let g:NERDTreeWinSize=40

" Highlight currently open buffer in NERDTree.
autocmd BufEnter * call SyncTree()

" Close vim when NERD tree is the only buffer left open.
autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Auto delete the buffer of a file just deleted w/NERDTree.
let NERDTreeAutoDeleteBuffer = 1

" NERDTree UI improvements.
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1

" =============================================================================
" EasyMotion

" Jump to anywhere you want with just one key binding: `s{char}{label}`.
nmap s <Plug>(easymotion-overwin-f)

" Jump to anywhere by searching for two chars in a row: `s{char}{char}{label}`.
nmap S <Plug>(easymotion-overwin-f2)

" Turn on case insensitive feature.
let g:EasyMotion_smartcase = 1

" Move down or up lines using EasyMotion.
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)

" =============================================================================
" GitGutter

" Shorter update time for gitgutter.
set updatetime=100

" Stage and undo hunks (in addition to default <Leader>hs and <Leader>hu).
nmap <Leader>ha <Plug>GitGutterStageHunk
nmap <Leader>hr <Plug>GitGutterUndoHunk

" Go to previous and next hunks (in addition to default ]c and [c).
nmap ]h <Plug>GitGutterNextHunk
nmap [h <Plug>GitGutterPrevHunk

" =============================================================================
" Miscellaneous

" Startify lists.
let g:startify_lists = [
      \ { 'type': 'dir',       'header': ['   MRU ' . getcwd()] },
      \ { 'type': 'bookmarks', 'header': ['   Bookmarks'] },
      \ { 'type': 'files',     'header': ['   MRU'] },
      \ ]

" Startify bookmarks.
let g:startify_bookmarks = [ '~/.vimrc', '~/.zshrc', '~/.zshrc-aliases', '~/.zshrc-functions', '~/.tmux.conf' ]

" Limit number of files on startify.
let g:startify_files_number = 5

" Set tab completion type.
let g:SuperTabDefaultCompletionType = ""

" Prevent super tab after newline or space.
let g:SuperTabNoCompleteAfter = ['\n', '\r', '\s']

" Local config.
if filereadable($HOME . "/.vimrc.local")
  source ~/.vimrc.local
endif
