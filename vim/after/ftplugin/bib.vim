setlocal nowrap

" Insert a new online reference from an URL that's on the clipboard.
" The BibTex entry `title` will be the page's HTML <title>, the `url` will be clipboard URL, and the `urldate` will be today's ISO date.
" Reference from: https://unix.stackexchange.com/a/103253/337515
nnoremap <nowait> <buffer> <Leader>r 
            \:read !pbpaste \| xargs curl --location --silent --show-error \| perl -l -0777 -ne 'print $1 if /<title.*?>\s*(.*?)\s*<\/title/si' \| recode html<CR>
            \Gzzo<Esc>o<C-U>@misc{,<Esc>
            \I<TAB>title = {{<Esc>A}},<CR>
            \url = {<C-R>+},<CR>
            \urldate = {<C-R>=strftime("%Y-%m-%d")<CR>
            \},<CR>}<Esc>4k$i

command! SOB so ~/.vim/after/ftplugin/bib.vim
