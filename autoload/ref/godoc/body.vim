" vim-ref-godoc - A ref source for go doc.
" Maintainer: obcat <obcat@icloud.com>
" License:    MIT License

let s:TABSTOP = repeat(' ', 4)

" @param query: string
" @return string
function ref#godoc#body#get(query)
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

" @param string: string
" @return string
function s:trim_empty_lines(string)
  return matchstr(a:string, '\v^\_s*\zs.{-}\ze\_s*$')
endfunction
