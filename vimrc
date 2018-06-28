set nocompatible    " makes sure all the features all available
set viminfo+=!,%,n~/vimfiles/.temp/_viminfo
let mapleader=' '   " use space as the leader key

" ============= PLUGINS =============

call plug#begin('~/vimfiles/plugged')
Plug 'tpope/vim-surround'            " edit braces easily
Plug 'tpope/vim-commentary'          " comment out lines
Plug 'tpope/vim-repeat'              " repeat plugin commands
Plug 'ap/vim-buftabline'             " buffers as tabs
Plug 'vim-scripts/AutoComplPop'      " always show autocompletion
Plug 'easymotion/vim-easymotion'     " KJump/easymotion for vim
Plug 'google/vim-searchindex'        " show x/y when searching
Plug 'machakann/vim-highlightedyank' " highlight yanks
Plug 'markonm/traces.vim'            " live substitution
Plug 'simnalamburt/vim-mundo'        " graphical undotree
Plug 'tommcdo/vim-lion'              " align text
Plug 'maxbrunsfeld/vim-yankstack'    " yank stack
Plug 'romainl/vim-tinyMRU'           " most recent files
call plug#end()

" maxbrunsfeld/vim-yankstack
let g:yankstack_map_keys = 0
call yankstack#setup()
nmap <C-P> <Plug>yankstack_substitute_older_paste
nmap <C-N> <Plug>yankstack_substitute_newer_paste

" easymotion/vim-easymotion
let g:EasyMotion_keys='asdghklqwertyuiopzxcvbnmfj'
let g:EasyMotion_do_shade=0
let g:EasyMotion_do_mapping=0
map s <Plug>(easymotion-bd-f)
map S <Plug>(easymotion-bd-t)

" machakann/vim-highlightedyank
let g:highlightedyank_highlight_duration=300

" simnalamburt/vim-mundo
let g:mundo_preview_statusline='Diff'
let g:mundo_tree_statusline='History'
let g:mundo_mirror_graph=0
let g:mundo_return_on_revert=0
let g:mundo_verbose_graph=0
nnoremap <silent><F2> :MundoToggle<CR>

" tommcdo/vim-lion
let g:lion_squeeze_spaces=1

" tpope/vim-surround
let g:surround_no_mappings=1
nmap dz  <Plug>Dsurround
nmap cz  <Plug>Csurround
nmap cZ  <Plug>CSurround
nmap yz  <Plug>Ysurround
nmap yZ  <Plug>YSurround
nmap yzz <Plug>Yssurround
nmap yZz <Plug>YSsurround
nmap yZZ <Plug>YSsurround
xmap Z   <Plug>VSurround
xmap gZ  <Plug>VgSurround

" romainl/vim-tinyMRU
set wildcharm=<C-Z>
nnoremap <Leader>m :ME <C-Z>



" ============= GENERAL =============

" set these only when vim starts, not when sourcing vimrc
if !exists('g:notfirstopen')
    let g:notfirstopen=1
    set lines=40 columns=120  " initial window size
    set guifont=Consolas:h12  " changing font moves the window
endif

" use cygwin bash as shell
let $CHERE_INVOKING=1
set shell=C:/cygwin64/bin/bash.exe
set shellcmdflag=--login\ -c
set shellxquote=\"
set noshellslash

" visuals
if !exists('g:BG')
    " make the global variable if it doesn't exist
    let g:BG=&background
endif
if g:BG == 'dark'
    set background=dark
else
    set background=light
endif
colorscheme solarized
let g:solarized_italic=0
syntax enable
set guioptions=
set guicursor+=a:blinkon0
set guicursor+=i-ci:ver20-blinkon0
set cursorline
set number relativenumber
set showmode showcmd
set cmdheight=2

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

" line wrapping
set wrap linebreak textwidth=0 wrapmargin=0 formatoptions-=t

" indentation settings
set tabstop=8 softtabstop=4 shiftwidth=4 expandtab
set smarttab  autoindent    smartindent  breakindent

" show unwanted whitespace on 'set list'
set nolist listchars=tab:>-,trail:.,nbsp:.

" search settings
set incsearch hlsearch ignorecase smartcase
let @/ = ''

" no errorbells
set noerrorbells
augroup NoVisualBells
    autocmd!
    autocmd GUIEnter * set visualbell t_vb=
augroup END

" language settings
let $LANG='en_US'
set encoding=utf-8
set fileformats=unix,dos

" temp file locations
set undofile
set undodir=~/vimfiles/.temp
set backupdir=~/vimfiles/.temp
set directory=~/vimfiles/.temp
set viewdir=~/vimfiles/.temp
let g:netrw_home='~/vimfiles/.temp'

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
set undolevels=5000            " remember more undo history
set history=1000               " remember more command history
set matchpairs=(:),{:},[:]     " configure which braces to match
set shortmess=a                " shorter prompt messages
set report=1                   " threshold when to report commands
filetype plugin indent on      " auto detect filetype
set sessionoptions-=options
set sessionoptions+=localoptions

" netrw config
let g:netrw_banner=0
let g:netrw_liststyle=3
let g:netrw_browse_split=4
let g:netrw_winsize=25



" ============= MAPPINGS =============

" vmap > xmap for ideavimc compatibility


" makes these keys easier to use
noremap , :
noremap : ;
noremap ; ,

" operate on visual lines rather than physicals lines
noremap k gk
noremap j gj
noremap 0 g0
noremap $ g$

" split navigations (alt+hjkl)
nnoremap è <C-W><C-H>
nnoremap ê <C-W><C-J>
nnoremap ë <C-W><C-K>
nnoremap ì <C-W><C-L>
tnoremap è <C-W><C-H>
tnoremap ê <C-W><C-J>
tnoremap ë <C-W><C-K>
tnoremap ì <C-W><C-L>

" cycle buffers (alt+nm)
nnoremap <silent>î :bprev<CR>
nnoremap <silent>í :bnext<CR>
tnoremap <silent>î <C-W>:bprev<CR>
tnoremap <silent>í <C-W>:bnext<CR>

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
nnoremap <silent><C-Down> :cnfile<CR><C-G>
nnoremap <silent><C-Up> :cpfile<CR><C-G>

" better autocompletion selection and make CR undoable
inoremap <expr> <TAB> pumvisible() ? '<C-Y>' : '<TAB>'
inoremap <expr> <CR> pumvisible() ? '<C-E><C-G>u<CR>' : '<C-G>u<CR>'

" make C-U and C-W undoable
inoremap <C-U> <C-G>u<C-U>
inoremap <C-W> <C-G>u<C-W>

" make Y behave the same way as D and C
nnoremap Y y$

" change enter behaviour
nnoremap <CR> o<Esc>
nnoremap <C-Enter> mzo<Esc>`z
nnoremap <S-Enter> O<Esc>
nnoremap <C-S-Enter> mzO<Esc>`z
nnoremap <Leader><CR> a<CR><Esc>

" use tab and backspace for indenting lines
nnoremap <S-BS> >>
nnoremap <BS> <<
vnoremap <S-BS> >gv
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

" navigate to tag (useful in help file 'links')
nnoremap <Leader>9 <C-]>

" toggle theme background
nnoremap <silent><F12> :call ToggleBackground()<CR>
function! ToggleBackground()
    if &background == 'dark'
        set background=light
        let g:BG='light'
    else
        set background=dark
        let g:BG='dark'
    endif
    colorscheme solarized
endfunction

" unmap push-to-talk key
map <F13> <Nop>
map! <F13> <Nop>

" temp for testing productdata
nnoremap <silent><Leader>cn :let @+ = "'" . expand("%:t:r") . "'"<CR>

nnoremap <silent><Leader>t :Vexplore<CR>


" ============= COMMANDS =============

" vim-plug commands
command! PI w | PlugInstall
command! PC w | PlugClean
command! PU w | PlugUpdate | PlugUpgrade

" source vimrc
command! SO so $MYVIMRC

" count lines in file
command! WC %s/^\s*\w\+//n | noh



" ============= AUTOCMD =============

" config for python files
augroup Python
    autocmd!
    " exceute current python file
    autocmd FileType python nnoremap <buffer> <silent><F5> :w<CR>:term ++rows=10 ++eof='' python %<CR>
    "                       nnoremap                  <F5> call term_sendkeys(buffer_number, "ls\<CR>")

    " highlight python keyword arguments
    " autocmd FileType python highlight PythonKwarg ctermfg=61 guifg=#6c71c4
augroup END

" toggle relative numbers between modes
augroup LineNumbers
    autocmd!
    autocmd InsertEnter * :set norelativenumber
    autocmd InsertLeave * :set relativenumber
augroup END
,
" source vimrc when it's saved
augroup ReloadVimrc
    autocmd!
    autocmd BufWritePost vimrc so $MYVIMRC
augroup END

" always save a view to have persistent folds
augroup AutoFolds
    autocmd!
    autocmd BufWrite ?* mkview
    autocmd BufRead ?* silent loadview
augroup END

" " open last files if invoked without arguments
" augroup AutoSession
"     autocmd!
"     autocmd VimLeave * silent mksession! ~/vimfiles/sessions/previous.vim | silent wviminfo!

"     autocmd VimEnter *
"             \ if argc() == 0 && filereadable($HOME . '/vimfiles/sessions/previous.vim')
"                \ | silent so ~/vimfiles/sessions/previous.vim |  endif
"             \ | silent so $MYVIMRC
"             \ | if filereadable($HOME . '/vimfiles/.temp/_viminfo')
"                 \ | silent rviminfo! | endif
" "            \ | silent call delete($HOME . '/vimfiles/sessions/previous.vim')
" augroup END


augroup AutoSession
    autocmd!
    autocmd VimLeave * silent silent wviminfo!
    autocmd VimEnter * silent so $MYVIMRC
                \ | if filereadable($HOME . '/vimfiles/.temp/_viminfo')
                    \ | silent rviminfo! | endif
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
