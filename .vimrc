" Install Vim plug & auto install Plugins
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Plugins
call plug#begin('~/.vim/plugged')
Plug 'wikitopian/hardmode'

Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-eunuch'
Plug 'jiangmiao/auto-pairs'

Plug 'ctrlpvim/ctrlp.vim'
Plug 'fatih/vim-go'
" Plug 'SirVer/ultisnips'
" Plug 'Valloric/YouCompleteMe', { 'do': './install.py' }
" Plug 'vim-syntastic/syntastic'
"Plug 'w0rp/ale'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree'
Plug 'airblade/vim-gitgutter'
Plug 'terryma/vim-multiple-cursors'

Plug 'vim-airline/vim-airline'
Plug 'altercation/vim-colors-solarized'
call plug#end()

set completeopt-=preview
let g:ycm_add_preview_to_completeopt=0

syntax enable
set background=dark
colorscheme solarized

set timeoutlen=1000 ttimeoutlen=0

hi MatchParen ctermbg=black ctermfg=none cterm=none

set hidden
set nu
set relativenumber

let g:netrw_liststyle = 3
let g:netrw_banner = 0

let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1

let mapleader=";"

" Delete without yanking
nnoremap <leader>d "_d

" Get the defaults that most users want.
source $VIMRUNTIME/defaults.vim

" Plugins
" UltiSnips
"let g:UltiSnipsExpandTrigger="<tab>"
"let g:UltiSnipsJumpForwardTrigger="<c-b>"
"let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" NERDTree
nnoremap <leader>n :NERDTreeToggle<CR>

" CTRL-P
"   Use the nearest .git directory as the cwd
"   This makes a lot of sense if you are working on a project that is in version
"   control. It also supports works with .svn, .hg, .bzr.
let g:ctrlp_working_path_mode = 'r'
"   Use a leader instead of the actual named binding
nnoremap <leader>p :CtrlP<cr>
"   Easy bindings for its various modes
nnoremap <leader>bb :CtrlPBuffer<cr>
nnoremap <leader>bm :CtrlPMixed<cr>
nnoremap <leader>be :CtrlPMRU<cr>

" Vim-go
nnoremap <F7> :GoDebugStep<CR>
nnoremap <F8> :GoDebugStep<CR>
nnoremap <F9> :GoDebugContinue<CR>
nnoremap <C-F8> :GoDebugBreakpoint<CR>
nnoremap <C-F9> :GoDebugBreakpoint<CR>



" Setup some default ignores
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/](\.(git|hg|svn)|\_site)$',
  \ 'file': '\v\.(exe|so|dll|class|png|jpg|jpeg)$',
\}

if has("vms")
  set nobackup				" do not keep a backup file, use versions instead
else
  set backup				" keep a backup file (restore to previous version)

  if empty(glob('~/.vim/.backup'))
    silent !mkdir ~/.vim/.backup > /dev/null 2>&1
  endif
  set backupdir=$HOME/.vim/.backup,.

  if has('persistent_undo')
    set undofile			" keep an undo file (undo changes after closing)
    if empty(glob('~/.vim/.undo'))
      silent !mkdir ~/.vim/.undo > /dev/null 2>&1
    endif
    set undodir=$HOME/.vim/.undo,.
  endif
endif

if &t_Co > 2 || has("gui_running")
  " Switch on highlighting the last used search pattern.
  set hlsearch
endif

" always set autoindenting on
set tabstop=4
set shiftwidth=4
set autoindent		
set expandtab
set smartindent

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  augroup END
endif " has("autocmd")


" Add optional packages.
"
" The matchit plugin makes the % command work better, but it is not backwards
" compatible.
" The ! means the package won't be loaded right away but when plugins are
" loaded during initialization.
if has('syntax') && has('eval')
  packadd! matchit
endif
