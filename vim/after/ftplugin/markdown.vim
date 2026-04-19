setlocal softtabstop=2 shiftwidth=2

nnoremap <buffer> <Leader>e <Cmd>write<BAR>execute 'silent !' .
    \ 'pandoc --output=' . shellescape(expand('%:p:r')) . '.pdf ' . shellescape(expand('%:p')) . ' && open ' . shellescape(expand('%:p:r')) . '.pdf &'
    \ <BAR>redraw!<CR>

command! -buffer SOT so ~/.vim/after/ftplugin/markdown.vim

let g:markdown_fenced_languages = [
    \ 'sh', 'bash', 'python', 'py=python', 'java', 'sql',
    \ 'javascript', 'js=javascript', 'typescript', 'ts=typescript', 'jsx=javascriptreact', 'tsx=typescriptreact',
    \ 'html', 'css', 'json', 'jsonc', 'yaml'
\]

" Enable spell checking and line length checking when editing pull request body with GitHub CLI tool.
" The file is created as a temp file with a name like: 123456789.md
if expand('%:p') =~# '^\(/private\)\?' . $TMPDIR . '\d\+\.md$'
    setlocal formatoptions=jt
    setlocal wrap
    setlocal spell
    setlocal textwidth=72
    setlocal colorcolumn=73
endif
