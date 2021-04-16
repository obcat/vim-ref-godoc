" vim-ref-godoc - A ref source for go doc.
" Maintainer: obcat <obcat@icloud.com>
" License:    MIT License

" Constants {{{1
let s:TABSTOP = repeat(' ', 4)

" Options {{{1
let g:ref_godoc_cmd = get(g:, 'ref_godoc_cmd', executable('go') ? 'go doc' : '')

" Create source {{{1
let s:source = {'name': 'godoc'}

function s:source.available()
  return !empty(g:ref_godoc_cmd)
endfunction

function s:source.get_keyword()
  return ref#godoc#keyword#get()
endfunction

function s:source.complete(arglead)
  return ref#godoc#complete#do(a:arglead)
endfunction

function s:source.normalize(query)
  return a:query
  \ ->substitute('\v\_s+', ' ', 'g')
  \ ->substitute('\v^ | $', '', 'g')
endfunction

function s:source.get_body(query)
  let g:ref_godoc_last_query = a:query
  let result = ref#system(ref#to_list(g:ref_godoc_cmd, a:query))
  if result.result == 0
    return s:trim_empty_lines(result.stdout)
  endif
  let errmsg = result.stderr
  \ ->s:trim_empty_lines()
  \ ->substitute('\t', s:TABSTOP, 'g')
  \ ->substitute('\v^doc: |\nexit status \d+$', '', 'g')
  throw errmsg == '' ? printf('no doc for %s', a:query) : errmsg
endfunction

" Register source {{{1
function ref#godoc#define()
  return copy(s:source)
endfunction

" Private functions {{{1
function s:trim_empty_lines(string)
  return matchstr(a:string, '\v^\_s*\zs.{-}\ze\_s*$')
endfunction

" Misc {{{1
call ref#register_detection('go', 'godoc')
