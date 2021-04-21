" vim-ref-godoc - A ref source for go doc.
" Maintainer: obcat <obcat@icloud.com>
" License:    MIT License

let s:Console = vital#ref_godoc#import('Vim.Console')
let s:Console.prefix = '[ref-godoc] '

" @param msg: string
" @param hl : string
function ref#godoc#console#echomsg(msg, hl = 'None') abort
  call s:Console.echomsg(a:msg, a:hl)
endfunction

" @param msg: string
" @param hl : string
function ref#godoc#console#echo(msg, hl = 'None') abort
  call s:Console.echo(a:msg, a:hl)
endfunction
