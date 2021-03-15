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
function ref#godoc#util#get_smart_cword()
  let line = getline('.')
  let col = col('.') - 1
  let [pre, post] = [strpart(line, 0, col), strpart(line, col)]
  let [not_kwddot, kwddot] = matchlist(post, '\v^([^.[:keyword:]]*)(\.?\k*)')[1 : 2]
  if not_kwddot == ''
    let kwddot = matchstr(pre, '\v[.[:keyword:]]*$') .. kwddot
  endif
  return trim(kwddot, '.', 1)
endfunction

" Get importpath from the content of current buffer. Example:
"
"     ------------------------------------------------------------------------
"     package json // import "encoding/json"
"
"     Package json implements encoding and decoding of JSON as defined in RFC
"     7159. The mapping between JSON and Go values is described in the
"     ...
"     ...
"     ------------------------------------------------------------------------
"
"     => encoding/json
function ref#godoc#util#get_importpath()
  return matchstr(getline(1), '^package \k\+ \/\/ import "\zs[/[:keyword:]]\+\ze"$')
endfunction
