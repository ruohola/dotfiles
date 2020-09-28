nnoremap <buffer> <silent> <Leader>e :write<BAR>:tabn 1<BAR>:<C-U>call RunCommandInSplitTerm('cargo run')<CR><BAR>:<CR>

" indentation settings
set tabstop=8 softtabstop=4 shiftwidth=4 expandtab
set smarttab  autoindent    breakindent
