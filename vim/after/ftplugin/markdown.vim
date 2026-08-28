setlocal softtabstop=2 shiftwidth=2
setlocal textwidth=105
setlocal wrap

nnoremap <buffer> <Leader>e <Cmd>call RunCommandInSplitTerm('go-grip --bounding-box=false --port "$(freeport)" ' . shellescape(expand('%:p')))<CR>

command! -buffer SOT so ~/.vim/after/ftplugin/markdown.vim

let g:markdown_fenced_languages = [
    \ 'sh', 'bash', 'python', 'py=python', 'java', 'sql',
    \ 'javascript', 'js=javascript', 'typescript', 'ts=typescript', 'jsx=javascriptreact', 'tsx=typescriptreact',
    \ 'html', 'css', 'json', 'jsonc', 'yaml', 'mermaid'
\]

" Settings for `zk` notes.
if !empty(finddir('.zk', escape(expand('%:p:h'), ' ,') . ';'))
    setlocal softtabstop=4 shiftwidth=4  " Obsidian can only use 4-space indents.
endif

" Enable spell checking and line length checking when editing pull request body with GitHub CLI tool.
" The file is created as a temp file with a name like: 123456789.md
if expand('%:p') =~# '^\(/private\)\?' . $TMPDIR . '\d\+\.md$'
    setlocal formatoptions=jt
    setlocal spell
    setlocal textwidth=72
    setlocal colorcolumn=73
endif
