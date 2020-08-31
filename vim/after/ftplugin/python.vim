nnoremap <buffer> <silent> <Leader>e :write<BAR>:<C-U>call RunCommandInSplitTerm('python3 ' . shellescape(expand('%:p')))<CR><BAR>:<CR>
nnoremap <buffer> <silent> <Leader>w :write<BAR>:<C-U>call RunCommandInSplitTerm('mypy ' . shellescape(expand('%:p')))<CR><BAR>:<CR>
nnoremap <buffer> <silent> <Leader>q :CocCommand python.setInterpreter<CR>

" indentation settings
set tabstop=8 softtabstop=4 shiftwidth=4 expandtab
set smarttab  autoindent    breakindent
