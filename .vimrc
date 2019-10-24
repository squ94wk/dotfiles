let mapleader=";"

source ~/.vim/plugins.vim           " Load plugins and configuration
source ~/.vim/statusline.vim        " Custom statusline
source $VIMRUNTIME/defaults.vim     " Get the defaults that most users want.

" Leader mappings
nnoremap <leader>d "_d
nnoremap <leader>x "_x

" visuals
syntax enable
set background=dark
colorscheme solarized
hi MatchParen ctermbg=black ctermfg=none cterm=none

if &t_Co > 2 || has("gui_running")
  " Switch on highlighting the last used search pattern.
  set hlsearch
  nnoremap <leader><leader> :nohl<CR>
endif

set timeoutlen=1000 ttimeoutlen=0
set hidden
set completeopt=longest,menuone

" Backup, Swap and Undo files
if has("vms")
  set nobackup				        " do not keep a backup file, use versions instead
else
  set backup				        " keep a backup file (restore to previous version)

  if empty(glob('~/.vim/.backup'))
    silent !mkdir ~/.vim/.backup > /dev/null 2>&1
  endif
  set backupdir=$HOME/.vim/.backup,.

  if has('persistent_undo')
    set undofile			        " keep an undo file (undo changes after closing)
    if empty(glob('~/.vim/.undo'))
      silent !mkdir ~/.vim/.undo > /dev/null 2>&1
    endif
    set undodir=$HOME/.vim/.undo,.
  endif
endif
if empty(glob('~/.vim/.swap'))
  silent !mkdir ~/.vim/.swap > /dev/null 2>&1
endif
set directory=$HOME/.vim/.swap,.

" always enable autoindenting
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

  autocmd BufWritePre * %s/\s\+$//e

  augroup END
endif " has("autocmd")
