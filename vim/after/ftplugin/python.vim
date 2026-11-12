nnoremap <buffer> <Leader>e <Cmd>call RunCommandInSplitTerm('uv run python ' . shellescape(expand('%:p')))<CR>
nnoremap <buffer> <Leader>w <Cmd>call RunCommandInSplitTerm('uv run mypy ' . shellescape(expand('%:p')))<CR>

" indentation settings
set tabstop=8 softtabstop=4 shiftwidth=4 expandtab
set smarttab  autoindent    breakindent
