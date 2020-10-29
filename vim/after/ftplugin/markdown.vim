setlocal spell

nnoremap <buffer> <Leader>e :<C-U>write<BAR>execute 'silent !' .
    \ 'pandoc --output=' . shellescape(expand('%:p:r')) . '.pdf ' . shellescape(expand('%:p')) . ' && open ' . shellescape(expand('%:p:r')) . '.pdf &'
    \ <BAR>redraw!<CR>

command! -buffer SOT so ~/.vim/after/ftplugin/markdown.vim

let g:markdown_fenced_languages = ['python', 'ruby']
