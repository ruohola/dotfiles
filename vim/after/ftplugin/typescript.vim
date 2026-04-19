nnoremap <buffer> <Leader>e <Cmd>call RunCommandInSplitTerm('npx ts-node ' . shellescape(expand('%:p')))<CR>

setlocal softtabstop=2 shiftwidth=2
