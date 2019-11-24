set textwidth=80
set formatoptions=jt

" change eol comment to line comment and vice versa
nnoremap <buffer> ä :set nohlsearch<CR>$?\v%<CR>gEl"_d/\v\%<CR>"qDO<C-R>q<Esc>^:set hlsearch<BAR>noh<CR>
nnoremap <buffer> <Leader>c a\cite{}<Left>
nnoremap <buffer> <Leader>i a\textit{}<Left>
nnoremap <buffer> <Leader>t a\texttt{}<Left>
nnoremap <buffer> <Leader>bv o\begin{verbatim}<Enter>\end{verbatim}<Esc>O
nnoremap <buffer> <Leader>bm o\begin{minipage}<Enter>\end{minipage}<Esc>

set tabstop=8 softtabstop=4 shiftwidth=4 expandtab
set smarttab  autoindent    breakindent

command! SOT so ~/.vim/after/ftplugin/tex.vim
