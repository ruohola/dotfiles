"""""""""MISC""""""""""

"makes sure all the features all available
set nocompatible

"clear all existing autocmds
autocmd!

"use cmd.exe as shell
" set shell=cmd.exe
" set noshellslash
" set shellquote="\""

"use git bash as shell
let $CHERE_INVOKING=1
set shell=C:/Program\ Files/Git/bin/bash.exe
set shellxquote=\"
" set shellslash
set noshellslash

"make the global variable if it doesn't exist
if !exists('g:BG')
   let g:BG=&background
endif

"make vim store g:CAPS variables to viminfo
set viminfo+=!

"clear the opened file argument list
%argdel


"""""""""PLUGINS""""""""""

call plug#begin('~/vimfiles/plugged')
Plug 'altercation/vim-colors-solarized'  "solarized colorscheme
Plug 'tpope/vim-surround'                "more text objects
Plug 'exvim/ex-aftercolors'              "edit a colorscheme
Plug 'scrooloose/nerdtree'               "file manager
Plug 'tpope/vim-commentary'              "comment out lines
Plug 'xolox/vim-misc'                    "required for vim-session
Plug 'xolox/vim-session'                 "session management
Plug 'ap/vim-buftabline'                 "buffers as tabs
Plug 'xolox/vim-shell'                   "fullscreen mode
Plug 'vim-scripts/AutoComplPop'          "always show autocompletion
Plug 'easymotion/vim-easymotion'         "KJump/easymotion for vim
Plug 'ctrlpvim/ctrlp.vim'                "fuzzy finder
Plug 'FelikZ/ctrlp-py-matcher'           "add-on for ctrlp
Plug 'google/vim-searchindex'            "show x/y when searching
call plug#end()

"altercation/vim-colors-solarized
"added cursorlinenumber coloring to line 622
colorscheme solarized
let g:solarized_italic=0

"xolox/vim-session
let g:session_autosave='yes'
let g:session_autoload='yes'
let g:session_default_overwrite=1
let g:session_default_to_last=1

"xolox/vim-shell
let g:shell_mappings_enabled=0

"xolox/vim-misc                    
"edited 2 lines to remove noruler and noshowmode

"easymotion/vim-easymotion
"changed line 26 in EasyMotion.vim to have better hotkeys
let g:EasyMotion_do_mapping=0

"ctrlpvim/ctrlp.vim 
let g:ctrlp_max_files=0
let g:ctrlp_clear_cache_on_exit=0

"FelikZ/ctrl-py-matcher
let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }



"""""""""GENERAL""""""""""

"theming
if !(&guifont == 'Consolas:h12')
    "changing font moves the window
    set guifont=Consolas:h12
endif
syntax enable
set guioptions-=m
set guioptions-=M
set guioptions-=T
set guioptions-=L
set guioptions-=l
set guioptions-=R
set guioptions-=r
set guioptions-=b
set guioptions-=e
set guioptions+=k

"statusline
set laststatus=2                                    "always show statusline
set statusline=                                     "clear statusline
set statusline+=%F                                  "filepath
<<<<<<< HEAD
=======
set statusline+=[%{strlen(&fenc)?&fenc:'none'},     "file encoding
set statusline+=%{&ff}]                             "file format
set statusline+=%y                                  "filetype
set statusline+=\ %F                                "tail of the filename
>>>>>>> 51047907ec6cef387b31d6e7f305623f7ff92426
set statusline+=%h                                  "help file flag
set statusline+=%m                                  "modified flag
set statusline+=%r                                  "read only flag
set statusline+=%=                                  "left/right separator
set statusline+=%l/%L                               "cursor line/total lines
<<<<<<< HEAD
set statusline+=:%c                                 "cursor column
=======
set statusline+=:%c\                                "cursor column
>>>>>>> 51047907ec6cef387b31d6e7f305623f7ff92426
set statusline+=\ [%{strlen(&fenc)?&fenc:'none'},   "file encoding
set statusline+=%{&ff}]                             "line endings
set statusline+=%y                                  "filetype
<<<<<<< HEAD
=======
set statusline+=:%c                                 "cursor column
>>>>>>> 51047907ec6cef387b31d6e7f305623f7ff92426

"visuals
set guicursor+=n-v-c:blinkon0
set guicursor+=i:ver25-blinkon0
set cursorline
set number
set relativenumber
set showmode
set showcmd

"line wrapping
set wrap
set linebreak
set textwidth=0
set wrapmargin=0
set formatoptions-=t

"indentation settings
set tabstop=8
set softtabstop=4
set shiftwidth=4
set expandtab
set smarttab
set autoindent
set smartindent

"search settings
set incsearch
set hlsearch
let @/ = ""
set ignorecase
set smartcase

"no errorbells
set noerrorbells visualbell t_vb=
autocmd GUIEnter * set visualbell t_vb=

"language settings
let $LANG='en_US'
set encoding=utf-8
set fileformats=unix,dos

"undo, backup, view and swapfiles
set undolevels=5000
set undofile
set undodir=~/vimfiles/undo
set backupdir=~/vimfiles/backup
set directory=~/vimfiles/swap
set viewdir=~/vimfiles/view
set viminfo+=n~/vimfiles/.viminfo
set updatecount=10

"mixed
set clipboard=unnamed               "use system clipboard
set backspace=indent,eol,start      "make backspace behave normally
set hidden                          "switch to another buffer without saving
set autoread                        "update changes to file automatically
set autochdir                       "automatically change working directory
set scrolloff=1                     "pad cursor row with lines
set splitright                      "open splits to rightside
set matchpairs+=<:>                 ""add <> to bracket matching
set wildmode=list:longest,full      "better tab completion on command line mode


"""""""""MAPPINGS""""""""""

"use space as the leader key
let mapleader=" "
 
"makes these keys easier to use
noremap , :
noremap : ;
noremap ; ,

"split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

"cycle buffers with alt+h and atl+l
nnoremap <silent>ì :bnext<CR>
nnoremap <silent>è :bprev<CR>

"use arrow keys to navigate after a :vimgrep or :helpgrep
nnoremap <silent><Down> :cnext<CR>
nnoremap <silent><Up> :cprev<CR>
nnoremap <silent><Leader><Down> :cnfile<CR><C-G>
nnoremap <silent><Leader><Up> :cpfile<CR><C-G>

"better autocompletion selection
imap <expr> <TAB> pumvisible() ? "<C-Y>" : "<TAB>"
imap <expr> <CR> pumvisible() ? "<C-E><CR>" : "<CR>"
imap <expr> <C-J> pumvisible() ? "<Down>" : "<C-J>"
imap <expr> <C-K> pumvisible() ? "<Up>" : "<C-K>"

"make Y behave the same way as D and C
nnoremap Y y$

"change enter behaviour
nnoremap <CR> o<Esc>
nnoremap <C-Enter> moo<Esc>`o
nnoremap <S-Enter> O<Esc>
nnoremap <C-S-Enter> moO<Esc>`o
nnoremap <Leader><CR> i<CR><Esc>

"use tab and backspace for indenting
nnoremap <Tab> >>
nnoremap <BS> <<
vnoremap <Tab> >gv 
vnoremap <BS> <gv

"Q plays back q macro
nnoremap Q @q

"dont copy to clipboard when editing with <Leader><key>
nnoremap <Leader>d "_d
nnoremap <Leader>D "_D
nnoremap <Leader>c "_c
nnoremap <Leader>C "_C
nnoremap <Leader>x "_x
nnoremap <Leader>X "_X
vnoremap <Leader>d "_d
vnoremap <Leader>D "_D
vnoremap <Leader>c "_c
vnoremap <Leader>C "_C
vnoremap <Leader>x "_x
vnoremap <Leader>X "_X

"don't show match highlights
nnoremap <silent><Esc> <Esc>:noh<CR>

"exceute current python file 
nnoremap <F5> :w<CR>:vert term python %<CR>
" nnoremap <F5> call term_sendkeys(buffer_number, "ls\<CR>")

"open vimrc
nnoremap <Leader>vr :e $MYVIMRC<CR>

"toggle theme background
nnoremap <F12> :call ToggleBackground()<CR>

"makes vim and ideavim comment actions more consistent
nmap <C-G> gccj
vmap <C-G> gcgv

"unmap push-to-talk key
map <F13> <Nop>
map! <F13> <Nop>

"toggle fullscreenmode
nnoremap <silent><F11> :Fullscreen<CR>:Maximize<CR>
nnoremap <silent><C-F11> :Maximize<CR>

"show NERDTree
nnoremap <silent><Leader>t :NERDTree<CR> 

"jump to char with easymotion
nmap <Leader>f <Plug>(easymotion-overwin-f)

"navigate to tag (useful in help file 'links')
nnoremap <Leader>9 <C-]>

"temp for testing productdata
nnoremap <silent><Leader>cn :let @+ = "'" . expand("%:t:r") . "'"<CR>


"""""""""COMMANDS""""""""""

"vim-plug commands
command! PI :PlugInstall
command! PC :PlugClean
command! PU :PlugUpdate

"source vimrc
command! SO :so $MYVIMRC


"""""""""FUNCTIONS""""""""""

"funtion to toggle between solarized dark/light
if !exists('*ToggleBackground')
    function! ToggleBackground()
        if &background == "dark"
            set background=light
            let g:BG="light"
        else
            set background=dark
            let g:BG="dark"
        endif
        colorscheme solarized
    endfunction
endif

"Only apply to help files...
function! HelpInNewTab()
    if &buftype == 'help'
        "Convert the help window to a tab
        execute "normal \<C-W>T"
    endif
endfunction


"""""""""AUTOCMD""""""""""

""toggle relative numbers between modes
augroup LineNumbers
    autocmd!
    autocmd InsertEnter * :set norelativenumber
    autocmd InsertLeave * :set relativenumber
augroup END

"source vimrc when it's saved
augroup Source
    autocmd!
    autocmd BufWritePost vimrc so $MYVIMRC
augroup END

"always save a view to have persistent folds
augroup AutoSaveFolds
    autocmd!
    autocmd BufWinLeave ?* mkview
    autocmd BufWinEnter ?* silent loadview 
augroup END

"Only apply to .txt files...
augroup HelpInTabs
    autocmd!
    autocmd BufEnter *.txt call HelpInNewTab()
augroup END
