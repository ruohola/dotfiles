nnoremap <buffer> <silent> <Leader>e :write<BAR>:<C-U>call RunCommandInSplitTerm('runghc ' . shellescape(expand('%:p')))<CR><BAR>:<CR>
