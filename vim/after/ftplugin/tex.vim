set textwidth=80
set formatoptions=jt

" change eol comment to line comment and vice versa
nnoremap ä :set nohlsearch<CR>$?\v%<CR>gEl"_d/\v\%<CR>"qDO<C-R>q<Esc>^:set hlsearch<BAR>noh<CR>
nnoremap <Leader>c a\cite{}<Left>
nnoremap <Leader>i a\textit{}<Left>
nnoremap <Leader>t a\texttt{}<Left>
nnoremap <Leader>b o\begin{verbatim}<Enter>\end{verbatim}<Esc>O

set tabstop=8 softtabstop=4 shiftwidth=4 expandtab
set smarttab  autoindent    breakindent
