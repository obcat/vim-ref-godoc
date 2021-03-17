" vim-ref-godoc - A ref source for Go.
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

function ref#godoc#util#prepend_pkgname(cword)
  let pkgname = matchstr(getline(1), '^package \zs\k\+\ze')
  if pkgname != '' && a:cword ==# s:extract_symbol_from_current_line()
    return pkgname .. '.' .. a:cword
  endif
  return a:cword
endfunction

function s:extract_symbol_from_current_line()
  let patterns = [
  \ '^\s*const \zs\k\+',
  \ '^\s*func \zs\k\+',
  \ '^\s*func (.\{-1,}) \zs\k\+',
  \ '^\s*type \zs\k\+',
  \ '^\s*var \zs\k\+',
  \ ]
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
