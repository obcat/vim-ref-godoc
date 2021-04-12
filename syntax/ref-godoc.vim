" vim-ref-godoc - A ref source for go doc.
" Maintainer: obcat <obcat@icloud.com>
" License:    MIT License

if exists('b:current_syntax')
  finish
endif
let b:current_syntax = 'ref-godoc'

syntax case match

syntax match refGodocPackageName '\%^package \zs\S\+'
highlight default link refGodocPackageName String

syntax region refGodocComment start='\%(\s\|^\)\zs//' end='$'
highlight default link refGodocComment Comment

syntax match refGodocSectionHeader '^\u\w*\%( \u\w*\)*$'
highlight default link refGodocSectionHeader Statement

" Highlight symbol names. Example:"{{{
"
"         v-------------v
"    type BenchmarkResult struct{ ... }
"        func Benchmark(f func(b *B)) BenchmarkResult
"             ^-------^
"
" NOTE: DO NOT Highlight in the following case:
"
"    Package testing provides support for automated testing of Go packages. It is
"    intended to be used in concert with the "go test" command, which automates
"    execution of any function of the form
"
"        func TestXxx(*testing.T) // <- DO NOT highlight this "TestXxx"!!
"
"    where Xxx does not start with a lowercase letter. The function name serves
"    to identify the test routine.
"
" FIXME: Not cool..."}}}
syntax match refGodocDeclarations contains=refGodocSymbolName '^\%(const\|var\|type\|func\) .*\%(\n \+\%(const\|var\|type\|func\).*\)*'
syntax match refGodocSymbolName contained '^ *\%(const\|var\|type\|func\%( ([^)]\+)\)\?\) \zs[^ (]\+'
highlight default link refGodocSymbolName Constant

syntax case ignore

syntax match refGodocTodo '\<\%(TODO\|FIXME\|XXX\|BUG\|NOTE\|DEPRECATED\|CHANGED\|IDEA\|HACK\|REVIEW\|NB\|QUESTION\|COMBAK\|TEMP\|DEBUG\|OPTIMIZE\|WARNING\)\ze\%(([^)]\+)\)\?:'
highlight default link refGodocTodo Todo
