" Install Vim plug & auto install Plugins
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Plugins
call plug#begin('~/.vim/plugged')
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

"Plug 'altercation/vim-colors-solarized'
call plug#end()

" Disable preview window
set completeopt-=preview
let g:ycm_add_preview_to_completeopt=0

let g:netrw_liststyle = 3
let g:netrw_banner = 0

let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1

let g:AutoPairsFlyMode = 1
"let g:AutoPairsShortcutBackInsert = '<M-b>' " default

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

" Setup some default ignores
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/](\.(git|hg|svn)|\_site)$',
  \ 'file': '\v\.(exe|so|dll|class|png|jpg|jpeg)$',
\}

" Vim-go
nnoremap <F7> :GoDebugStep<CR>
nnoremap <F8> :GoDebugStep<CR>
nnoremap <F9> :GoDebugContinue<CR>
nnoremap <C-F8> :GoDebugBreakpoint<CR>
nnoremap <C-F9> :GoDebugBreakpoint<CR>

" Plugins
" UltiSnips
"let g:UltiSnipsExpandTrigger="<tab>"
"let g:UltiSnipsJumpForwardTrigger="<c-b>"
"let g:UltiSnipsJumpBackwardTrigger="<c-z>"

