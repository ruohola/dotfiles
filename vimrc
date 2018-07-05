set viminfo+=!,%,n~/vimfiles/.temp/_viminfo
let g:mapleader=' '

" ============= PLUGINS =============

" disable netrw
let g:loaded_netrw=1
let g:loaded_netrwPlugin=1

call plug#begin('~/vimfiles/plugged')
Plug 'tpope/vim-surround'              " edit braces easily
Plug 'tpope/vim-commentary'            " comment out lines
Plug 'tpope/vim-repeat'                " repeat plugin commands
Plug 'pacha/vem-tabline'               " buffers as tabs
Plug 'easymotion/vim-easymotion'       " KJump/easymotion for vim
Plug 'google/vim-searchindex'          " show [x/y] when searching
Plug 'machakann/vim-highlightedyank'   " highlight yanks
Plug 'markonm/traces.vim'              " live substitution
Plug 'simnalamburt/vim-mundo'          " graphical undotree
Plug 'maxbrunsfeld/vim-yankstack'      " remember past yanks
Plug 'vim-scripts/ReplaceWithRegister' " operator to replace text
Plug 'wellle/targets.vim'              " more text objects
Plug 'tommcdo/vim-exchange'            " echange two objects
Plug 'davidhalter/jedi-vim'            " python autocompletion etc
Plug 'w0rp/ale'                        " automatic linting
Plug 'terryma/vim-smooth-scroll'       " smooth scrolling
Plug 'Yggdroot/LeaderF'                " fuzzy finding
Plug 'scrooloose/nerdtree'             " file browser
Plug 'chrisbra/Colorizer'              " preview colors
Plug 'junegunn/vim-easy-align'         " align text with motion
Plug 'chriskempson/base16-vim'         " base16 colorschemes
Plug 'mhartington/oceanic-next'        " oceanic colorschme
call plug#end()

" scrooloose/nerdtree
nnoremap <silent> <F1> :NERDTreeToggle<CR>

" Yggdroot/LeaderF
let g:Lf_StlColorscheme='default'
let g:Lf_CursorBlink=0
let g:Lf_UseVersionControlTool=0
let g:Lf_DefaultExternalTool='rg'
let g:Lf_ShowHidden=1
let TempFolder = $HOME . '/vimfiles/.temp'
let g:Lf_CacheDirectory=TempFolder
let g:Lf_IndexTimeLimit=600
let g:Lf_UseCache=1
let g:Lf_HighlightIndividual=1
let g:Lf_NumberOfHighlight=100
let g:Lf_UseMemoryCache=1
let g:Lf_WildIgnore = {
        \ 'dir': ['.git'],
        \ 'file': []
        \}
let g:Lf_ShortcutF='<Leader>p'
nnoremap <Leader>l :LeaderfLine<CR>
nnoremap <Leader>o :LeaderfLineAll<CR>
nnoremap <Leader>k :LeaderfHelp<CR>
nnoremap <Leader>n :LeaderfBufferAll<CR>
nnoremap <Leader>m :LeaderfMru<CR>
nnoremap <Leader>ö :LeaderfSelf<CR>

" w0rp/ale
let g:ale_sign_column_always=0
let g:ale_change_sign_column_color=1
let g:ale_set_signs=1
let g:ale_max_signs=-1
let g:ale_use_global_executables=1
let g:ale_linters_explicit=1
let g:ale_set_quickfix=1
let g:ale_linters = {'python': ['flake8', 'mypy'], 'vim': ['vint']}
let g:ale_fixers  = {'python': ['autopep8', 'isort']}
let g:ale_lint_on_enter=0
let g:ale_lint_on_text_changed='never'
let g:ale_lint_on_filetype_changed=0
let g:ale_lint_on_insert_leave=0
let g:ale_lint_on_save=1
let g:ale_fix_on_save=0

" davidhalter/jedi-vim
let g:jedi#goto_command='<C-]>'
let g:jedi#goto_assignments_command='<Leader>a'
let g:jedi#documentation_command='K'
let g:jedi#rename_command='<Leader>r'
let g:jedi#usages_command='<Leader>u'

" maxbrunsfeld/vim-yankstack
let g:yankstack_map_keys = 0
nmap <C-P> <Plug>yankstack_substitute_older_paste
nmap <C-N> <Plug>yankstack_substitute_newer_paste
call yankstack#setup()

" easymotion/vim-easymotion
let g:EasyMotion_keys='asdghklqwertyuiopzxcvbnmfj'
let g:EasyMotion_do_shade=0
let g:EasyMotion_do_mapping=0
nmap <Leader>f <Plug>(easymotion-bd-f)
nmap <Leader>t <Plug>(easymotion-bd-t)

" machakann/vim-highlightedyank
let g:highlightedyank_highlight_duration=300

" simnalamburt/vim-mundo
let g:mundo_preview_statusline='Diff'
let g:mundo_tree_statusline='History'
let g:mundo_mirror_graph=0
let g:mundo_return_on_revert=0
let g:mundo_verbose_graph=0
nnoremap <silent> <F2> :MundoToggle<CR>

" junegunn/vim-easy-align
nmap gl <Plug>(EasyAlign)
xmap gl <Plug>(EasyAlign)

" vim-scripts/ReplaceWithRegister
nmap s <Plug>ReplaceWithRegisterOperator
nmap ss <Plug>ReplaceWithRegisterLine
xmap s <Plug>ReplaceWithRegisterVisual
nnoremap S s

" terryma/vim-smooth-scroll
nnoremap <silent> <C-U> :call smooth_scroll#up(&scroll, 0, 2)<CR>
nnoremap <silent> <C-D> :call smooth_scroll#down(&scroll, 0, 2)<CR>
nnoremap <silent> <C-B> :call smooth_scroll#up(&scroll*2, 0, 4)<CR>
nnoremap <silent> <C-F> :call smooth_scroll#down(&scroll*2, 0, 4)<CR>

" pacha/vem-tabline
let g:vem_tabline_show=2



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
" colorscheme solarized
" let g:solarized_italic=0
colorscheme OceanicNext
syntax enable
set guioptions=
set guicursor+=a:blinkon0
set guicursor+=i-ci:ver20-blinkon0
set cursorline
set number relativenumber
set showmode showcmd
set report=1
set cmdheight=2

" statusline
set laststatus=2                                      " always show statusline
set statusline=                                       " clear statusline
set statusline+=%<                                    " start to truncate here
set statusline+=\|%{getcwd()}\|                       " current working dir
set statusline+=\ %F                                  " filepath
set statusline+=%h                                    " help file flag
set statusline+=%m                                    " modified flag
set statusline+=%r                                    " read only flag

function! LinterStatus() abort
    let l:counts = ale#statusline#Count(bufnr(''))
    let l:all_errors = l:counts.error + l:counts.style_error
    let l:all_non_errors = l:counts.total - l:all_errors

    return l:counts.total == 0 ? '' : printf(
    \ '[%dW %dE]',
    \ all_non_errors,
    \ all_errors,
    \)
endfunction
set statusline+=\ %{LinterStatus()}                   " ALE status

set statusline+=%=                                    " left/right separator
set statusline+=%l/%L                                 " cursor line/total lines
set statusline+=(%p%%)                                " percentage through the file
set statusline+=\<%2c                                 " cursor column
set statusline+=/%2{strwidth(getline('.'))}\>           " line length
set statusline+=[%{strlen(&ft)?(&ft\ .\ \',\'):''}  " filetype
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
set fileformats=unix,dos
set encoding=utf-8
scriptencoding utf-8

" temp file locations
set undofile
set undodir=~/vimfiles/.temp
set backupdir=~/vimfiles/.temp
set directory=~/vimfiles/.temp
set viewdir=~/vimfiles/.temp

" mixed settings
set clipboard=unnamed          " use system clipboard
set backspace=indent,eol,start " make backspace behave normally
set hidden                     " switch to another buffer without saving
set autoread                   " update changes to file automatically
" set autochdir                  " automatically change working directory
set scrolloff=1                " pad cursor row with lines
set splitright                 " open splits to the right
set splitbelow                 " open splits to the bottom
set wildmode=list:longest,full " better tab completion on command line mode
set undolevels=5000            " remember more undo history
set history=1000               " remember more command history
set matchpairs=(:),{:},[:]     " configure which braces to match
set shortmess=a                " shorter prompt messages
filetype plugin indent on      " auto detect filetype



" ============= MAPPINGS =============

" makes these easier to use
noremap , :
tnoremap , :
noremap : ;
noremap ; ,
augroup QMappings
    autocmd!
    autocmd FileType * if &l:buftype ==? '' |nnoremap <buffer> <silent> q, q:| endif
    autocmd FileType * if &l:buftype ==? 'nofile' |nnoremap <buffer> <silent> q :q<CR>| endif
augroup END

" traverse history with alt+,.
nnoremap ® g,
nnoremap ¬ g;

" " makes these easier to use in fin layout
" noremap ¤ $
" noremap § `
" noremap ½ ~
" noremap g½ g~
" noremap - /
" noremap q- q/
" noremap + ?
" noremap q+ q?

" make Y behave the same way as D and C
nnoremap Y y$

" testing if this is good
xnoremap v V
noremap V <Nop>

" search for selected text
xnoremap <Leader>/ "zy/\V<C-R>=escape(@z,'/\')<CR><CR>

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
nnoremap <silent> î :bprev<CR>
nnoremap <silent> í :bnext<CR>
tnoremap <silent> î <C-W>:bprev<CR>
tnoremap <silent> í <C-W>:bnext<CR>

" cycle tabs (alt+ui)
nnoremap õ gT
nnoremap é gt

" make C-J/C-K work as Down/Up
noremap <C-J> <Down>
noremap <C-K> <Up>
noremap! <C-J> <Down>
noremap! <C-K> <Up>

" insert diagrahs with C-L instead of C-K
inoremap <C-L> <C-K>

" navigate quickfix list and vimgrep
nnoremap <silent> <Down> :cnext<CR>
nnoremap <silent> <Up> :cprev<CR>
nnoremap <silent> <C-Down> :cnfile<CR><C-G>
nnoremap <silent> <C-Up> :cpfile<CR><C-G>

" better autocompletion selection and make CR undoable
inoremap <expr> <TAB> pumvisible() ? '<C-Y>' : '<TAB>'
inoremap <expr> <CR> pumvisible() ? '<C-E><C-G>u<CR>' : '<C-G>u<CR>'

" make C-U and C-W undoable
inoremap <C-U> <C-G>u<C-U>
inoremap <C-W> <C-G>u<C-W>

" change enter behaviour
augroup EnterMappings
    " FIXME: ei toimi tyhjissä tiedostoissa!
    autocmd!
    autocmd FileType * if &l:buftype ==? ''
            \| nnoremap <buffer> <CR> o<Esc>
            \| nnoremap <buffer> <S-Enter> O<Esc>
            \| nnoremap <buffer> <C-Enter> :<C-U>call <SID>BlankDown(v:count1)<CR>
            \| nnoremap <buffer> <C-S-Enter> :<C-U>call <SID>BlankUp(v:count1)<CR>
            \| nnoremap <buffer> <Leader><CR> a<CR><Esc>
            \| endif
augroup END
function! s:BlankUp(count) abort
    :norm! mz
    put!=repeat(nr2char(10), a:count)
    silent! call repeat#set("\<Plug>unimpairedBlankUp", a:count)
    :norm! `z
endfunction
function! s:BlankDown(count) abort
    :norm! mz
    put =repeat(nr2char(10), a:count)
    silent! call repeat#set("\<Plug>unimpairedBlankDown", a:count)
    :norm! `z
endfunction

" backspace for indenting lines
nnoremap <S-BS> >>
nnoremap <BS> <<
xnoremap <S-BS> >gv
xnoremap <BS> <gv

" persistent visual selection
xnoremap > >gv
xnoremap < <gv
xnoremap gc :norm gcc<CR>gv

" Q plays back q macro
nnoremap Q @q

" " don't copy to clipboard when editing with <Leader>d
nnoremap <Leader>d "_d
nnoremap <Leader>D "_D
xnoremap <Leader>d "_d

" don't show match highlights
nnoremap <silent> <Esc> <Esc>:noh<CR>

" open vimrc
nnoremap <Leader>vr :e $MYVIMRC<CR>

" toggle theme background
nnoremap <silent> <F12> :call ToggleBackground()<CR>

" toggle fullscreen
nnoremap <F11> :call libcallnr("gvimfullscreen.dll", "ToggleFullScreen", 0)<CR>

" unmap push-to-talk key
map <F13> <Nop>
map! <F13> <Nop>

" temp for testing productdata
nnoremap <silent> <Leader>cn :let @+ = "'" . expand("%:t:r") . "'"<CR>

" close current buffer
nnoremap <Leader>b :bd<CR>



" ============= COMMANDS =============

" vim-plug commands
command! PI w | PlugInstall
command! PC w | PlugClean!
command! PU w | PlugUpdate | PlugUpgrade

" source vimrc
command! SO so $MYVIMRC

" count lines in file
command! WC %s/^\s*\w\+//n | noh



" ============= FUNCTIONS =============


function! s:RunCommandInSplitTerm(command)
    write
    let winSize = float2nr(0.3 * winheight('$'))
    let mainBuf = bufnr('%')
    let termBufNr = get(b:, '_run_term', -1)
    let termWinNr = bufwinnr(termBufNr)

    if termWinNr == -1
        exe 'below split | resize ' . winSize
        let termBufNr = term_start('bash -l', {
                    \ 'curwin': 1,
                    \ 'term_finish': 'close',
                    \ })
    else
        exe termWinNr . 'wincmd w'
    endif

    let mainWin = bufwinnr(mainBuf)
    call term_sendkeys(termBufNr, a:command . "\<CR>")
    exe "normal \<C-W>w"
endfunction

function! ToggleBackground()
    if &background ==? 'dark'
        set background=light
        let g:BG='light'
    else
        set background=dark
        let g:BG='dark'
    endif
    colorscheme solarized
endfunction



" ============= AUTOCMD =============

" config for python files
augroup Python
    autocmd!
    " exceute current python file
    autocmd FileType python nnoremap <buffer> <silent> <F5>
                \ :call <SID>RunCommandInSplitTerm('python ' . shellescape(expand('%:p')))<CR>
augroup END

" toggle relative numbers between modes
augroup LineNumbers
    autocmd!
    autocmd InsertEnter * set norelativenumber
    autocmd InsertLeave * set relativenumber
augroup END

" source vimrc when it's saved
augroup ReloadVimrc
    autocmd!
    autocmd BufWritePost vimrc so $MYVIMRC
augroup END

" handle vim opening and closing
augroup VimBoot
    autocmd!
     autocmd VimLeave * silent wviminfo
    autocmd VimEnter * silent so $MYVIMRC
                \| if filereadable($HOME . '/vimfiles/.temp/_viminfo')
                    \| silent rviminfo
                    \| let &background=g:BG
                \| endif
augroup END

" configure opening of help windows
augroup HelpInTabs
    function! HelpInNewTab()
        if &buftype ==? 'help'
            exe "normal \<C-W>o"
        endif
    endfunction

    autocmd!
    autocmd BufRead *.txt call HelpInNewTab()
augroup END

" clear trailing whitespace on save
augroup TrimWhitespace
    autocmd!
    autocmd BufWritePre *vimrc :%s/\s\+$//e
augroup END



" ============= REGISTERS =============

" clear the search register for no highlighting
let @/=''
" macro to add a plugin
let @p='gg/call plug#end()OPlug ''+'' " glip-"nkA '
