if has('win32')
    nnoremap <buffer> <silent> <Leader>e :write<BAR>:tabn 1<BAR>:<C-U>call RunCommandInSplitTerm('python ' . shellescape(expand('%:p')))<CR><BAR>:<CR>
else
    nnoremap <buffer> <silent> <Leader>e :write<BAR>:tabn 1<BAR>:<C-U>call RunCommandInSplitTerm('python3 ' . shellescape(expand('%:p')))<CR><BAR>:<CR>
endif

" change eol comment to line comment and vice versa
nnoremap ä :set nohlsearch<CR>$?\v#<CR>gEl"_d/\v\#<CR>"qDO<C-R>q<Esc>^:set hlsearch<BAR>noh<CR>

" indentation settings
set tabstop=8 softtabstop=4 shiftwidth=4 expandtab
set smarttab  autoindent    breakindent
