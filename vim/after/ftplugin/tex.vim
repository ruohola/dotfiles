set textwidth=80
set formatoptions=jt

" change eol comment to line comment and vice versa
nnoremap ä :set nohlsearch<CR>$?\v%<CR>gEl"_d/\v\%<CR>"qDO<C-R>q<Esc>^:set hlsearch<BAR>noh<CR>
nnoremap <Leader>c a\cite{}<Left>
nnoremap <Leader>i a (\textit{})<Left><Left>
