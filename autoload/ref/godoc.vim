" vim-ref-godoc - A ref source for go doc.
" Maintainer: obcat <obcat@icloud.com>
" License:    MIT License

let g:ref_godoc_cmd = get(g:, 'ref_godoc_cmd', executable('go') ? 'go doc' : '')

let s:source = {'name': 'godoc'}

function s:source.available()
  return !empty(g:ref_godoc_cmd)
endfunction

function s:source.get_keyword()
  return ref#godoc#keyword#get()
endfunction

function s:source.complete(query)
  return ref#godoc#complete#do(a:query)
endfunction

function s:source.normalize(query)
  return a:query->trim()->substitute('\_s\+', ' ', 'g')
endfunction

function s:source.get_body(query)
  return ref#godoc#body#get(a:query)
endfunction

function ref#godoc#define()
  return copy(s:source)
endfunction

call ref#register_detection('go', 'godoc')
