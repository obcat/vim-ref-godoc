" vim-ref-godoc - A ref source for go doc.
" Maintainer: obcat <obcat@icloud.com>
" License:    MIT License

if exists('b:current_syntax')
  finish
endif
let b:current_syntax = 'ref-godoc'

syntax sync minlines=20

syntax match refGodocPackage nextgroup=refGodocPackageName skipwhite '\v%^package @='
syntax match refGodocPackageName contained '\v[^ ]+'
highlight default link refGodocPackageName String

syntax region refGodocComment start='\v%(^|\s)@1<=//' end='$'
highlight default link refGodocComment Comment

" A line is considered as a heading if it meets all of the following 7 conditions:{{{
"
"    1. The previous two lines are blank.
"    2. The line starts with an uppercase letter.
"    3. The line does not contain any of these characters: ^;:!?+*/=[]{}_^°&§~%#@<">\ .
"    4. The line does not contain any single quotation marks (') that are not followed by "s ".
"    5. The line does not contain any of dots (.) that are not followed by the non-space.
"    6. The line ends in a letter or digit.
"    7. The next line is blank.
"
" The conditions 2 through 6 correspond this function: https://github.com/golang/go/blob/49e933fc57c2f858e19c26f4a2e56ba94fc54989/src/go/doc/comment.go#L214.}}}
syntax match refGodocHeading -\v^\n\n\u%(%([^;:!?+*/=[\]{}_^°&§~%#@<">\\'.]|'%(s )@=|\. @!)+|)%(\a|\d)\n$-
syntax match refGodocHeading '\v^%(CONSTANTS|VARIABLES|FUNCTIONS|TYPES)$'
highlight default link refGodocHeading Statement

" Highlight symbol names. Example:{{{
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
"}}}
syntax match refGodocDeclarationChunk contains=refGodocDeclarationStart '\v^%(const|var|func|type) .+\n%( +%(const|var|func|type) .+\n)*'
syntax match refGodocDeclarationStart contained nextgroup=refGodocSymbolName skipwhite '\v^ *%(const|var|type) @='
syntax match refGodocDeclarationStart contained nextgroup=refGodocReciever,refGodocSymbolName skipwhite '\v^ *func @='
" Take into account the correspondence of nested parentheses to depth 3.{{{
" The pattern is taken from this blog post: https://www.kaoriya.net/blog/2019/12/01/.}}}
syntax match refGodocReciever contained nextgroup=refGodocSymbolName skipwhite '\v\([^()]*%(\([^()]*%(\([^()]*\)[^()]*)*\)[^()]*)*\) @='
syntax match refGodocSymbolName contained '\v[^ (]+'
highlight default link refGodocSymbolName Constant

" Taken from this plugin: itchyny/vim-highlighturl. Thanks!
syntax match refGodocURL '\v\c%(%(h?ttps?|ftp|file|ssh|git)://|[a-z]+[@][a-z]+[.][a-z]+:)%([&:#*@~%_\-=?!+;/0-9a-z]+%(%([.;/?]|[.][.]+)[&:#*@~%_\-=?!+/0-9a-z]+|:\d+|,%(%(%(h?ttps?|ftp|file|ssh|git)://|[a-z]+[@][a-z]+[.][a-z]+:)@![0-9a-z]+))*|\([&:#*@~%_\-=?!+;/.0-9a-z]*\)|\[[&:#*@~%_\-=?!+;/.0-9a-z]*\]|\{%([&:#*@~%_\-=?!+;/.0-9a-z]*|\{[&:#*@~%_\-=?!+;/.0-9a-z]*\})\})+'
highlight default link refGodocURL String

" The keywords are taken from this article: https://qiita.com/taka-kawa/items/673716d77795c937d422.
syntax match refGodocTodo '\v\c<%(TODO|FIXME|XXX|BUG|NOTE|DEPRECATED|CHANGED|IDEA|HACK|REVIEW|NB|QUESTION|COMBAK|TEMP|DEBUG|OPTIMIZE|WARNING)%(%(\([^()]+\))?:)@='
highlight default link refGodocTodo Todo
