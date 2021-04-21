command! -nargs=? -complete=customlist,s:complete RefGodocBrowse call ref#godoc#command#browse(<q-args>)

function s:complete(arglead, cmdline, cursorpos) abort
  return ref#godoc#complete#do(a:arglead)
endfunction
