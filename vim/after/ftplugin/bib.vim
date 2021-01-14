setlocal nowrap

nnoremap <nowait> <buffer> <Leader>r Go<Esc>o@misc{,<CR>title = {},<CR>url = {},<CR>urldate = {<C-R>=strftime("%Y-%m-%d")<CR>},<CR>}<Esc>2k$hh

command! SOB so ~/.vim/after/ftplugin/bib.vim
