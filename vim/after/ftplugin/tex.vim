setlocal textwidth=80
setlocal formatoptions=jt

" change eol comment to line comment and vice versa
nnoremap <buffer> ä :set nohlsearch<CR>$?\v%<CR>gEl"_d/\v\%<CR>"qDO<C-R>q<Esc>^:set hlsearch<BAR>noh<CR>
nnoremap <buffer> <Leader>c a\cite{}<Left>
nnoremap <buffer> <Leader>i a\textit{}<Left>
nnoremap <buffer> <Leader>en a(engl. \textit{})<Left><Left>
nnoremap <buffer> <Leader>t a\texttt{}<Left>
nnoremap <buffer> <Leader>bv o\begin{verbatim}<Enter>\end{verbatim}<Esc>O

setlocal tabstop=8 softtabstop=4 shiftwidth=4 expandtab
setlocal smarttab  autoindent    breakindent

setlocal updatetime=1

nnoremap <Leader>p :LLPStartPreview<CR>
command! SOT so ~/.vim/after/ftplugin/tex.vim
