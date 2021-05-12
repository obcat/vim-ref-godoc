" vim-ref-godoc - A ref source for go doc.
" Maintainer: obcat <obcat@icloud.com>
" License:    MIT License

" @param query: string
" @return list<string>
function ref#godoc#complete#do(query)
  let arglead = matchstr(a:query, '\S\+$')
  if arglead =~ '^-'
    " TODO: Should return flags which the "go doc" command support?
    return []
  endif
  return s:packages()->s:forward_match(arglead)
endfunction

" @return list<string>
function s:packages()
  let packages = []
  let packages += ref#cache('godoc', 'standard_packages', { -> s:standard_packages() })
  let packages += ['builtin']
  " TODO: Add packages related to the current script.
  return packages->sort()->uniq()
endfunction

" @return list<string>
function s:standard_packages()
  return ref#system(['go', 'list', 'std']).stdout
  \ ->split("\n")->filter({ _, v -> v !~# '^vendor/' })
endfunction

" @param texts: list<string>
" @param text : string
" @return list<string>
function s:forward_match(texts, text)
  let pattern = '^\V'
  \          .. (s:should_ignore_case(a:text) ? '\c' : '\C')
  \          .. escape(a:text, '\')
  return a:texts->filter({ _, v -> v =~ pattern })
endfunction

" See ":help 'smartcase'".
"
" @param text: string
" @return boolean
function s:should_ignore_case(text)
  let yes = &ignorecase
  if yes && &smartcase && a:text =~ '\u'
    let yes = v:false
  endif
  return yes
endfunction
