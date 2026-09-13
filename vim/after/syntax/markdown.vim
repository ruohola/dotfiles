" Highlight (GitHub's) MathJax blocks as LaTeX math in Markdown files:
"   $...$        inline math
"   $`...`$      inline math, backtick form
"   $$...$$      display math (may span lines)
"   ```math      display math fence
"
" Pin the runtime syntax file instead of letting `syntax/tex.vim` resolve
" through the runtimepath: once a `.tex` file has been opened, vimtex is
" lazy-loaded onto it and ships its own `tex.vim` with different group names.
" `syn include` needs `b:current_syntax` unset, as tex.vim bails out otherwise.
let s:current_syntax = get(b:, 'current_syntax', '')
unlet! b:current_syntax
syn include @markdownMathTex $VIMRUNTIME/syntax/tex.vim
unlet! b:current_syntax
if !empty(s:current_syntax)
    let b:current_syntax = s:current_syntax
endif
" tex.vim sets a buffer-wide `syn iskeyword`; restore Markdown's 'iskeyword'.
syn iskeyword clear

" `@texMathZoneGroup` is what tex.vim puts inside `$...$` & friends, so the
" contents highlight as math instead of as top level LaTeX.
let s:contains = 'contains=@texMathZoneGroup,@NoSpell'

" Items matching at the same position are resolved last definition first,
" hence `$` before `$$` and the backtick form.
execute 'syn region markdownMath matchgroup=markdownMathDelimiter'
    \ . ' start="\\\@1<!\$\$\@!\ze\S" end="\S\@1<=\$\d\@!" skip="\\\$"'
    \ . ' oneline keepend ' . s:contains
execute 'syn region markdownMath matchgroup=markdownMathDelimiter'
    \ . ' start="\\\@1<!\$`" end="`\$"'
    \ . ' oneline keepend ' . s:contains
execute 'syn region markdownMathBlock matchgroup=markdownMathDelimiter'
    \ . ' start="\\\@1<!\$\$" end="\$\$" skip="\\\$"'
    \ . ' keepend ' . s:contains
execute 'syn region markdownMathBlock matchgroup=markdownCodeDelimiter'
    \ . ' start="^\s*\z(`\{3,\}\)\s*math\>.*$" end="^\s*\z1\ze\s*$"'
    \ . ' keepend ' . s:contains
execute 'syn region markdownMathBlock matchgroup=markdownCodeDelimiter'
    \ . ' start="^\s*\z(\~\{3,\}\)\s*math\>.*$" end="^\s*\z1\ze\s*$"'
    \ . ' keepend ' . s:contains

unlet s:contains

" Also highlight math inside headings, blockquotes and the like.
syn cluster markdownInline add=markdownMath,markdownMathBlock

hi def link markdownMath texMath
hi def link markdownMathBlock texMath
hi def link markdownMathDelimiter Delimiter
