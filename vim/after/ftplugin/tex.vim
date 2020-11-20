setlocal textwidth=80
setlocal formatoptions=jt
setlocal nowrap
setlocal updatetime=1000
setlocal spell

nnoremap <nowait> <buffer> <Leader>c a\cite{}<Left>
nnoremap <nowait> <buffer> <Leader>s a\cite[s.~]{}<Left><Left><Left>
nnoremap <nowait> <buffer> <Leader>i a\textit{}<Left>
nnoremap <nowait> <buffer> <Leader>e a (engl. \textit{})<Left><Left>
nnoremap <nowait> <buffer> <Leader>t a\texttt{}<Left>
nnoremap <nowait> <buffer> <Leader>b o\begin{verbatim}<Enter>\end{verbatim}<Esc>O<Tab>
nnoremap <nowait> <buffer> <Leader>p :LLPStartPreview<CR>

setlocal tabstop=8 softtabstop=4 shiftwidth=4 expandtab
setlocal smarttab  autoindent    breakindent

command! SOT so ~/.vim/after/ftplugin/tex.vim
