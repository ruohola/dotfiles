nnoremap <buffer> <silent> <Leader>e :write<BAR>:tabn 1<BAR>:<C-U>call RunCommandInSplitTerm('cargo run')<CR><BAR>:<CR>

" change eol comment to line comment and vice versa
nnoremap ä :set nohlsearch<CR>$?\v//<CR>gEl"_d/\v\//<CR>"qDO<C-R>q<Esc>^:set hlsearch<BAR>noh<CR>

" indentation settings
set tabstop=8 softtabstop=4 shiftwidth=4 expandtab
set smarttab  autoindent    breakindent
