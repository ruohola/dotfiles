set textwidth=80
set formatoptions+=t

" change eol comment to line comment and vice versa
nnoremap ä :set nohlsearch<CR>$?\v%<CR>gEl"_d/\v\%<CR>"qDO<C-R>q<Esc>^:set hlsearch<BAR>noh<CR>
