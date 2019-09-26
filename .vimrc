set timeoutlen=1000 ttimeoutlen=0

syntax on

let mapleader=";"

" Delete without register
nnoremap <leader>d "_d

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Get the defaults that most users want.
source $VIMRUNTIME/defaults.vim

" Plugins
set runtimepath^=~/.vim/bundle/ctrlp.vim

" Setup some default ignores
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/](\.(git|hg|svn)|\_site)$',
  \ 'file': '\v\.(exe|so|dll|class|png|jpg|jpeg)$',
\}

" Use the nearest .git directory as the cwd
" This makes a lot of sense if you are working on a project that is in version
" control. It also supports works with .svn, .hg, .bzr.
let g:ctrlp_working_path_mode = 'r'

" Use a leader instead of the actual named binding
nnoremap <leader>p :CtrlP<cr>

" Easy bindings for its various modes
nnoremap <leader>bb :CtrlPBuffer<cr>
nnoremap <leader>bm :CtrlPMixed<cr>
nnoremap <leader>be :CtrlPMRU<cr>


if has("vms")
  set nobackup				" do not keep a backup file, use versions instead
else
  set backup				" keep a backup file (restore to previous version)
  set backupdir=$HOME/.vim/.backup,.
  if has('persistent_undo')
    set undofile			" keep an undo file (undo changes after closing)
    set undodir=$HOME/.vim/.undo,.
  endif
endif

if &t_Co > 2 || has("gui_running")
  " Switch on highlighting the last used search pattern.
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  autocmd Filetype python setlocal tabstop=4
  autocmd Filetype python setlocal shiftwidth=4

  augroup END

else

  set tabstop=4
  set shiftwidth=4

endif " has("autocmd")

set autoindent		" always set autoindenting on
set expandtab
set smartindent

" Add optional packages.
"
" The matchit plugin makes the % command work better, but it is not backwards
" compatible.
" The ! means the package won't be loaded right away but when plugins are
" loaded during initialization.
if has('syntax') && has('eval')
  packadd! matchit
endif
