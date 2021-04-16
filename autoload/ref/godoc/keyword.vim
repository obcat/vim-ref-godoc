" vim-ref-godoc - A ref source for go doc.
" Maintainer: obcat <obcat@icloud.com>
" License:    MIT License

" @return string
function ref#godoc#keyword#get()
  let cword = s:smart_cword()
  if cword == ''
    throw 'no identifier under cursor'
  endif
  return s:add_prefix(cword)
endfunction

" Get cword smartly. Examples ("|" is cursor):{{{
"
"     | foo.bar.baz  =>  foo
"       f|o.bar.baz  =>  foo
"       foo|bar.baz  =>  foo.bar
"       foo.b|r.baz  =>  foo.bar
"       foo.bar|baz  =>  foo.bar.baz
"       foo.bar.b|z  =>  foo.bar.baz
"     | ...nyaooooo  =>  nyaooooo
"
" FIXME: dirty :(
"}}}
" @return string
function s:smart_cword()
  let line = getline('.')
  let col = col('.') - 1
  let post = strpart(line, col)
  let [not_kwddot, kwddot] = matchlist(post, '\v^([^.[:keyword:]]*)(\.?\k*)')[1 : 2]
  if not_kwddot == ''
    let pre = strpart(line, 0, col)
    let kwddot = matchstr(pre, '\v[.[:keyword:]]*$') .. kwddot
  endif
  return trim(kwddot, '.', 1)
endfunction

" @param cword: string
" @return string
function s:add_prefix(cword)
  let filetype = &filetype ==# 'ref-godoc'
  \ ? 'ref_godoc' : 'go'
  return s:{filetype}_add_prefix(a:cword)
endfunction

" @param cword: string
" @return string
function s:ref_godoc_add_prefix(cword)
  if a:cword ==# s:symbol_on_cursor_line()
    let importpath = s:importpath()
    if importpath != '' && importpath != '.'
      return importpath .. '.' .. a:cword
    endif
  endif
  return a:cword
endfunction

" @return string
function s:symbol_on_cursor_line()
  let patterns = [
  \ '\v^ *%(const|var|func|type) \zs[^ (]+',
  \ '\v^ *func \([^()]*%(\([^()]*%(\([^()]*\)[^()]*)*\)[^()]*)*\) \zs[^ (]+',
  \]
  let line = getline('.')
  let symbol = ''
  for pattern in patterns
    let symbol = matchstr(line, pattern)
    if symbol != ''
      break
    endif
  endfor
  return symbol
endfunction

" @param cword: string
" @return string
function s:go_add_prefix(cword)
  return a:cword
endfunction

" @return string
function s:importpath()
  return matchstr(getline(1), '\v^package [^ ]+ // import "\zs.*\ze"$')
endfunction
