" vim-ref-godoc - A ref source for go doc.
" Maintainer: obcat <obcat@icloud.com>
" License:    MIT License

" @param importpath: string
function ref#godoc#command#browse(importpath)
  let importpath = a:importpath
  if importpath == ''
    if &filetype != 'ref-godoc'
      let msg = printf('Argument required, except in ref-viewer of ref-godoc.')
      call ref#godoc#console#echomsg(msg, 'ErrorMsg')
      return
    endif
    let importpath = ref#godoc#keyword#importpath()
    if importpath == '' || importpath == '.'
      let msg = printf('Importpath "%s" cannot be used in URL.', importpath)
      call ref#godoc#console#echomsg(msg, 'ErrorMsg')
      return
    endif
  endif
  let url = printf('https://pkg.go.dev/%s', importpath)
  call ref#godoc#util#open_browser(url)
  let msg = printf('Opening %s ... Done!', url)
  call ref#godoc#console#echo(msg)
endfunction
