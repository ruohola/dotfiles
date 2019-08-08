" change eol comment to line comment and vice versa
nnoremap ä :set nohlsearch<CR>$?\v"<CR>gEl"_d/\v\"<CR>"qDO<C-R>q<Esc>^:set hlsearch<BAR>noh<CR>

" indentation settings
let b:sleuth_automatic = 0
set tabstop=8 softtabstop=4 shiftwidth=4 expandtab
set smarttab  autoindent    breakindent
