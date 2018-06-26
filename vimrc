" ============= MISC =============

" makes sure all the features all available
set nocompatible

" clear all existing autocmds
autocmd!

" use cygwin bash as shell
let $CHERE_INVOKING=1
set shell=C:/cygwin64/bin/bash.exe
set shellcmdflag=--login\ -c
set shellxquote=\"
set noshellslash

" make vim store g:CAPS variables to viminfo
set viminfo+=!

" clear the opened file argument list for vim-session
%argdel



" ============= PLUGINS =============

call plug#begin('~/vimfiles/plugged')
Plug 'altercation/vim-colors-solarized' " solarized colorscheme
Plug 'vim-scripts/AfterColors.vim'      " edit solarized
Plug 'tpope/vim-surround'               " more text objects
Plug 'tpope/vim-commentary'             " comment out lines
Plug 'xolox/vim-misc'                   " required for xolox plugins
Plug 'xolox/vim-session'                " session management
Plug 'xolox/vim-shell'                  " fullscreen mode
Plug 'ap/vim-buftabline'                " buffers as tabs
Plug 'vim-scripts/AutoComplPop'         " always show autocompletion
Plug 'easymotion/vim-easymotion'        " KJump/easymotion for vim
Plug 'google/vim-searchindex'           " show x/y when searching
Plug 'machakann/vim-highlightedyank'    " highlight yanks
Plug 'markonm/traces.vim'               " live substitution
Plug 'godlygeek/tabular'                " align text
Plug 'simnalamburt/vim-mundo'           " graphical undotree
Plug 'terryma/vim-multiple-cursors'     " multiple cursors
call plug#end()

" altercation/vim-colors-solarized
" - own modifications on line 678->
if !exists('g:BG')
    " make the global variable if it doesn't exist
   let g:BG=&background
endif
let g:solarized_italic=0
colorscheme solarized
let &background=g:BG
syntax enable

" xolox/vim-session
let g:session_autosave='yes'                           " always save session
let g:session_autoload='yes'                           " always load session
let g:session_default_overwrite=1                      " always rewrite 'default' session
let g:session_default_to_last=1                        " open last session automatically

" xolox/vim-shell
let g:shell_mappings_enabled=0                         " disable default mappings

" xolox/vim-misc
" - edited 2 lines to remove noruler and noshowmode

" easymotion/vim-easymotion
let g:EasyMotion_keys='jfhgurlsowmxapqzncbvytiekd'     " better hotkeys
let g:EasyMotion_do_shade=0                            " don't disable colors on activation
let g:EasyMotion_do_mapping=0                          " disable default mappings

" machakann/vim-highlightedyank
let g:highlightedyank_highlight_duration=300           " adjust yank highlight duration

" simnalamburt/vim-mundo
let g:mundo_preview_statusline="Diff"                  " diff panel statusline
let g:mundo_tree_statusline="History"                  " history panel statusline
let g:mundo_mirror_graph=0                             " align graph to left
let g:mundo_return_on_revert=0                         " keep focus on the graph
let g:mundo_verbose_graph=0                            " configure graph length



" ============= GENERAL =============

" theming
if !(&guifont == 'Consolas:h12')
    " changing font moves the window
    set guifont=Consolas:h12
endif
set guioptions-=m guioptions-=M guioptions-=T guioptions-=L guioptions-=l
set guioptions-=R guioptions-=r guioptions-=b guioptions-=e guioptions+=k

" statusline
set laststatus=2                                      " always show statusline
set statusline=                                       " clear statusline
set statusline+=%F                                    " filepath
set statusline+=%h                                    " help file flag
set statusline+=%m                                    " modified flag
set statusline+=%r                                    " read only flag
set statusline+=%=                                    " left/right separator
set statusline+=L:%l/%L                               " cursor line/total lines
set statusline+=\ C:%c                                " cursor column
set statusline+=/%{strwidth(getline('.'))}            " line length
set statusline+=\ [%{strlen(&ft)?(&ft\ .\ \',\'):''}  " filetype
set statusline+=%{strlen(&fenc)?(&fenc\ .\ \',\'):''} " file encoding
set statusline+=%{&ff}]                               " line endings

" visuals
set guicursor+=a:blinkon0
set guicursor+=i-ci:ver20-blinkon0
set cursorline
set number relativenumber
set showmode showcmd
set cmdheight=2

" netrw config
let g:netrw_banner=0
let g:netrw_liststyle=3
let g:netrw_browse_split=4
let g:netrw_winsize=25

" line wrapping
set wrap linebreak textwidth=0 wrapmargin=0 formatoptions-=t

" indentation settings
set tabstop=8 softtabstop=4 shiftwidth=4 expandtab
set smarttab autoindent smartindent breakindent

" show unwanted whitespace on 'set list'
set nolist listchars=tab:>-,trail:.,nbsp:.

" search settings
set incsearch hlsearch ignorecase smartcase
let @/ =""

" no errorbells
set noerrorbells visualbell t_vb=
autocmd GUIEnter * set visualbell t_vb=

" language settings
let $LANG='en_US'
set encoding=utf-8
set fileformats=unix,dos

" undo, backup, view and swapfiles
set undolevels=5000
set updatecount=10
set undofile
set undodir=~/vimfiles/.temp
set backupdir=~/vimfiles/.temp
set directory=~/vimfiles/.temp
set viewdir=~/vimfiles/.temp
set viminfo+=n~/vimfiles/.temp/_viminfo

" mixed settings
set clipboard=unnamed          " use system clipboard
set backspace=indent,eol,start " make backspace behave normally
set hidden                     " switch to another buffer without saving
set autoread                   " update changes to file automatically
set autochdir                  " automatically change working directory
set scrolloff=1                " pad cursor row with lines
set splitright                 " open splits to the right
set splitbelow                 " open splits to the bottom
set wildmode=list:longest,full " better tab completion on command line mode
set history=1000               " remember more command history
set matchpairs=(:),{:},[:]     " configure which braces to match
set shortmess=a                " shorter prompt messages
set report=0                   " threshold when to report commands
set tildeop                    " use ~ as an operator



" ============= MAPPINGS =============

" vmap > xmap for ideavimc compatibility

" use space as the leader key
let mapleader=" "

" makes these keys easier to use
noremap , :
noremap : ;
noremap ; ,

" operate on visual lines rather than physicals lines
noremap <silent>k gk
noremap <silent>j gj
noremap <silent>0 g0
noremap <silent>$ g$

" split navigations (alt+hjkl)
nnoremap <silent>è <C-W><C-H>
nnoremap <silent>ê <C-W><C-J>
nnoremap <silent>ë <C-W><C-K>
nnoremap <silent>ì <C-W><C-L>

" cycle buffers (alt+nm)
nnoremap <silent>î :bprev<CR>
nnoremap <silent>í :bnext<CR>

" cycle tabs (alt+ui)
nnoremap õ gT
nnoremap é gt

" make C-J/C-K work as Down/Up
noremap <C-J> <Down>
noremap <C-K> <Up>
noremap! <C-J> <Down>
noremap! <C-K> <Up>

" use arrow keys to navigate after a :vimgrep or :helpgrep
nnoremap <silent><Down> :cnext<CR>
nnoremap <silent><Up> :cprev<CR>
nnoremap <silent><Leader><Down> :cnfile<CR><C-G>
nnoremap <silent><Leader><Up> :cpfile<CR><C-G>

" better autocompletion selection and make CR undoable
inoremap <expr> <TAB> pumvisible() ? "<C-Y>" : "<TAB>"
inoremap <expr> <CR> pumvisible() ? "<C-E><C-G>u<CR>" : "<C-G>u<CR>"

" make C-U and C-W undoable
inoremap <C-U> <C-G>u<C-U>
inoremap <C-W> <C-G>u<C-W>

" make Y behave the same way as D and C
nnoremap Y y$

" change enter behaviour
nnoremap <CR> o<Esc>
nnoremap <C-Enter> moo<Esc>`o
nnoremap <S-Enter> O<Esc>
nnoremap <C-S-Enter> moO<Esc>`o
nnoremap <Leader><CR> i<CR><Esc>

" use tab and backspace for indenting
nnoremap <Tab> >>
nnoremap <BS> <<
vnoremap <Tab> >gv
vnoremap <BS> <gv

" Q plays back q macro
nnoremap Q @q

" dont copy to clipboard when editing with <Leader><key>
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

" don't show match highlights
nnoremap <silent><Esc> <Esc>:noh<CR>

" open vimrc
nnoremap <Leader>vr :e $MYVIMRC<CR>

" toggle theme background
nnoremap <F12> :call ToggleBackground()<CR>

" makes vim and ideavim comment actions more consistent
nmap <C-G> gccj
vmap <C-G> gcgv

" unmap push-to-talk key
map <F13> <Nop>
map! <F13> <Nop>

" toggle fullscreenmode
nnoremap <silent><F11> :Fullscreen<CR>:Maximize<CR>
nnoremap <silent><C-F11> :Maximize<CR>

" toggle Mundo
nnoremap <silent><F2> :MundoToggle<CR>

" find char with easymotion
map <Leader>f <Plug>(easymotion-bd-f)
map <Leader>t <Plug>(easymotion-bd-t)

" navigate to tag (useful in help file 'links')
nnoremap <Leader>9 <C-]>

" temp for testing productdata
nnoremap <silent><Leader>cn :let @+ = "'" . expand("%:t:r") . "'"<CR>



" ============= COMMANDS =============

" vim-plug commands
command! PI PlugInstall
command! PC PlugClean
command! PU PlugUpdate | PlugUpgrade

" source vimrc
command! SO so $MYVIMRC

" count lines in file
command! WC  /^\s*[^"]\w\+/



" ============= FUNCTIONS =============

" funtion to toggle between solarized dark/light
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
        highlight PythonKwarg ctermfg=61 guifg=#6c71c4
    endfunction
endif



" ============= AUTOCMD =============

" config for python files
augroup Python
    autocmd!
    " exceute current python file
    autocmd FileType python nnoremap <buffer> <silent><F5> :w<CR>:term ++rows=10 ++eof='' python %<CR>
    "                       nnoremap                  <F5> call term_sendkeys(buffer_number, "ls\<CR>")

    " highlight python keyword arguments
    autocmd FileType python highlight PythonKwarg ctermfg=61 guifg=#6c71c4
augroup END

" toggle relative numbers between modes
augroup LineNumbers
    autocmd!
    autocmd InsertEnter * :set norelativenumber
    autocmd InsertLeave * :set relativenumber
augroup END

" source vimrc when it's saved
augroup Source
    autocmd!
    autocmd BufWritePost vimrc so $MYVIMRC
augroup END

" always save a view to have persistent folds
augroup AutoSaveFolds
    autocmd!
    autocmd BufWrite ?* mkview
    autocmd BufRead ?* silent loadview
augroup END

" open help in a new buffer fullscreen
augroup HelpInTabs

    function! HelpInNewTab()
        if &buftype == 'help'
            execute "normal \<C-W>o"
        endif
    endfunction

    autocmd!
    autocmd BufEnter *.txt call HelpInNewTab()
augroup END

" fix enter behaviour in specific buffers
augroup EnterBehaviour
    autocmd!
    autocmd CmdwinEnter * nnoremap <buffer> <CR> <CR>
    autocmd BufReadPost quickfix nnoremap <buffer> <CR> <CR>
augroup END

" clear trailing whitespace on save
augroup TrimWhitespace
    autocmd!
    autocmd BufWritePre *vimrc,*.py :%s/\s\+$//e
augroup END
