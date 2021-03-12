" vim-ref-godoc - A ref source for Go.
" Maintainer: obcat <obcat@icloud.com>
" License:    MIT License

" Options {{{1
let g:ref_godoc_cmd = get(g:, 'ref_godoc_cmd', executable('go') ? ['go', 'doc'] : '')

" Create source (|ref-sources|) {{{1
let s:source = {'name': 'godoc'}

" |ref-source-attr-available()|
function s:source.available()
  return !empty(g:ref_godoc_cmd)
endfunction

" |ref-source-attr-get_body()|
function s:source.get_body(query)
  let result = ref#system(ref#to_list(g:ref_godoc_cmd, a:query))
  if result.result == 0 && result.stdout != ''
    return result.stdout
  endif
  throw result.stderr == ''
  \ ? printf('no doc for %s', a:query)
  \ : split(result.stderr, '\r\?\n')[0]
endfunction

" Register source (|ref-autoload|) {{{1
function ref#godoc#define()
  return copy(s:source)
endfunction

" Misc {{{1
call ref#register_detection('go', 'godoc')
