" vim-ref-godoc - A ref source for Go.
" Maintainer: obcat <obcat@icloud.com>
" License:    MIT License

function ref#godoc#ftplugin#call()
  let undo_ftplugin = get(b:, 'undo_ftplugin', '')
  let b:undo_ftplugin = (undo_ftplugin == '' ? '' : undo_ftplugin .. ' | ')
  \ .. 'setlocal list<'
  setlocal nolist
endfunction
