" Render a diff below the commit message buffer for the `_vim-githistorycommit` script.

function! githistorycommit#render_diff (path) abort
    " Virtual text is not part of the buffer, so it never gets syntax
    " highlighted (hence highlighting it by hand, with the groups that the
    " `diff` filetype uses) and can never end up in the commit message.
    for [l:type, l:highlight] in items(#{
                \ diffFile: 'Type',
                \ diffLine: 'DiffText',
                \ diffAdded: 'Added',
                \ diffRemoved: 'Removed',
                \ diffIndex: 'PreProc',
                \ diffContext: 'Normal'})
        call prop_type_add(l:type, #{highlight: l:highlight})
    endfor

    for l:line in readfile(a:path)
        if l:line =~# '^@@'
            let l:type = 'diffLine'
        elseif l:line =~# '^index '
            let l:type = 'diffIndex'
        elseif l:line =~# '^\(+++\|---\|diff \|new \|deleted \|rename \|similarity \)'
            let l:type = 'diffFile'
        elseif l:line =~# '^+'
            let l:type = 'diffAdded'
        elseif l:line =~# '^-'
            let l:type = 'diffRemoved'
        else
            let l:type = 'diffContext'
        endif
        call prop_add(line('$'), 0, #{
                    \ type: l:type,
                    \ text: empty(l:line) ? ' ' : l:line,
                    \ text_align: 'below'})
    endfor
endfunction
