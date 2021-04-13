" vim-ref-godoc - A ref source for go doc.
" Maintainer: obcat <obcat@icloud.com>
" License:    MIT License

" Get cword smartly. Examples ("|" is cursor):
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
function ref#godoc#util#smart_cword()
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

function ref#godoc#util#add_prefix(cword)
  return &filetype ==# 'ref-godoc'
  \ ? s:add_prefix_ref_godoc(a:cword) : s:add_prefix_go(a:cword)
endfunction

" In a buffer which filetype is go.
function s:add_prefix_go(cword)
  return a:cword
endfunction

" In a ref-viewer of ref-godoc.
function s:add_prefix_ref_godoc(cword)
  if a:cword ==# s:symbol_on_cursor_line()
    let importpath = matchstr(getline(1), '\v^package [^ ]+ // import "\zs.*\ze"$')
    if importpath != '' && importpath != '.'
      return importpath .. '.' .. a:cword
    endif
  endif
  return a:cword
endfunction

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
