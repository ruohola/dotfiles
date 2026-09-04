setlocal softtabstop=2 shiftwidth=2
setlocal textwidth=105
setlocal wrap

nnoremap <buffer> <Leader>e <Cmd>call RunCommandInSplitTerm('go-grip --bounding-box=false --port "$(freeport)" ' . shellescape(expand('%:p')), 0.10)<CR>

" Prepend a securemodelines header, that enables spell checking and
" undoing the `textwidth` above so the file isn't hard wrapped.
nnoremap <buffer> <silent> <Leader>M <Cmd>execute "normal! ggO<!-- vim: tw=0 spell -->"<Bar>noautocmd write<Bar>doautocmd SecureModeLines BufRead<Bar>normal! ``<CR>

command! -buffer SOT so ~/.vim/after/ftplugin/markdown.vim

let g:markdown_fenced_languages = [
    \ 'sh', 'shell=sh', 'bash', 'python', 'py=python', 'java', 'sql',
    \ 'javascript', 'js=javascript', 'typescript', 'ts=typescript', 'jsx=javascriptreact', 'tsx=typescriptreact',
    \ 'html', 'css', 'json', 'jsonc', 'yaml', 'mermaid'
\]

" Settings for `zk` notes.
if !empty(finddir('.zk', escape(expand('%:p:h'), ' ,') . ';'))
    setlocal softtabstop=4 shiftwidth=4  " Obsidian can only use 4-space indents.
    " Notes are the only place Finnish is written. Vim ships no Finnish spell
    " file, so the large `spell/fi.utf-8.spl` is self-built.
    " Makes sense to only load it when needed.
    setlocal spelllang=en_us,fi
    " Put the securemodeline to the YAML frontmatter instead of the file beginning.
    " It's cleaner and Obsidian won't otherwise even render the frontmatter.
    nnoremap <buffer> <silent> <Leader>M <Cmd>execute "normal! ggo# vim: tw=0 spell"<Bar>noautocmd write<Bar>doautocmd SecureModeLines BufRead<Bar>normal! ``<CR>
endif

" Enable spell checking and line length checking when editing pull request body with GitHub CLI tool.
" The file is created as a temp file with a name like: 123456789.md
if expand('%:p') =~# '^\(/private\)\?' . $TMPDIR . '\d\+\.md$'
    setlocal formatoptions=jt
    setlocal spell
    setlocal textwidth=72
    setlocal colorcolumn=73
endif
