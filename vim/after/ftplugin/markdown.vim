setlocal formatoptions=jt
setlocal nowrap

nnoremap <buffer> <Leader>e :<C-U>write<BAR>execute 'silent !' .
    \ 'pandoc --output=' . shellescape(expand('%:p:r')) . '.pdf ' . shellescape(expand('%:p')) . ' && open ' . shellescape(expand('%:p:r')) . '.pdf &'
    \ <BAR>redraw!<CR>

command! -buffer SOT so ~/.vim/after/ftplugin/markdown.vim

let g:markdown_fenced_languages = ['python', 'ruby']

" Enable spell checking and line length checking when editing pull request body with GitHub CLI tool.
" The file is created as a temp file with a name like: 123456789.md
if @% =~# '\d\+\.md'
    setlocal spell
    setlocal textwidth=72
    setlocal colorcolumn=73
endif
