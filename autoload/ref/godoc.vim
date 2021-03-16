" vim-ref-godoc - A ref source for Go.
" Maintainer: obcat <obcat@icloud.com>
" License:    MIT License

" Constants {{{1
let s:TABSTOP = repeat(' ', 4)

" Options {{{1
let g:ref_godoc_cmd = get(g:, 'ref_godoc_cmd', executable('go') ? ['go', 'doc'] : '')
let g:ref_godoc_smart_cword = get(g:, 'ref_godoc_smart_cword', 1)
let g:ref_godoc_auto_prepend_importpath = get(g:, 'ref_godoc_auto_prepend_importpath', 1)

" Create source (|ref-sources|) {{{1
let s:source = {'name': 'godoc'}

" |ref-source-attr-available()|
function s:source.available()
  return !empty(g:ref_godoc_cmd)
endfunction

" |ref-source-attr-get_keyword()|
function s:source.get_keyword()
  let cword = g:ref_godoc_smart_cword
  \ ? ref#godoc#util#get_smart_cword() : expand('<cword>')
  if cword == ''
    throw 'no identifier under cursor'
  endif
  return cword
endfunction

" |ref-source-attr-normalize()|
function s:source.normalize(query)
  let prefix = g:ref_godoc_auto_prepend_importpath ? ref#godoc#util#get_importpath() : ''
  return prefix == '' ? a:query : (prefix .. '.' .. a:query)
endfunction

" |ref-source-attr-get_body()|
" NOTE: No need to check if return value is not empty.{{{
" If it is empty, vim-ref displays error message like
" "ref: godoc: The body is empty (query={query})" rather than opening empty buffer.}}}
function s:source.get_body(query)
  let result = ref#system(ref#to_list(g:ref_godoc_cmd, a:query))
  if result.result == 0
    return ref#godoc#util#trim_empty_lines(result.stdout)
  endif
  let errmsg = result.stderr
  \ ->ref#godoc#util#trim_empty_lines()
  \ ->substitute('\t', s:TABSTOP, 'g')
  \ ->substitute('^doc: \|\nexit status \d\+$', '', 'g')
  throw errmsg == '' ? printf('no doc for %s', a:query) : errmsg
endfunction

" |ref-source-attr-opened()|
function s:source.opened(query)
  call ref#godoc#syntax#call()
endfunction

" Register source (|ref-autoload|) {{{1
function ref#godoc#define()
  return copy(s:source)
endfunction

" Misc {{{1
call ref#register_detection('go', 'godoc')
