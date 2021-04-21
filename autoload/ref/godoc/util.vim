" vim-ref-godoc - A ref source for go doc.
" Maintainer: obcat <obcat@icloud.com>
" License:    MIT License

let s:File = vital#ref_godoc#import('System.File')

" @param url: string
function ref#godoc#util#open_browser(url) abort
  call s:File.open(a:url)
endfunction
