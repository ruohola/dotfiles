if has('win32')
    nnoremap <buffer> <silent> <Leader>e :write<BAR>:tabn 1<BAR>:<C-U>call RunCommandInSplitTerm('python ' . shellescape(expand('%:p')))<CR><BAR>:<CR>
else
    nnoremap <buffer> <silent> <Leader>e :write<BAR>:tabn 1<BAR>:<C-U>call RunCommandInSplitTerm('python3 ' . shellescape(expand('%:p')))<CR><BAR>:<CR>
endif
