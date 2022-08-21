nnoremap <buffer> <silent> <Leader>e :write<BAR>:<C-U>call RunCommandInSplitTerm('node ' . shellescape(expand('%:p')))<CR><BAR>:<CR>

setlocal softtabstop=2 shiftwidth=2
