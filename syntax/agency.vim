" Vim syntax file
" Language:    Agency
" Maintainer:  Generated from the Agency VS Code TextMate grammar
" Filenames:   *.agency

if exists("b:current_syntax")
  finish
endif

" Agency is case-sensitive
syntax case match

" ---------------------------------------------------------------------------
" Comments
" ---------------------------------------------------------------------------
syntax keyword agencyTodo contained TODO FIXME XXX NOTE HACK
syntax region  agencyComment start="/\*" end="\*/" contains=agencyTodo,@Spell
syntax match   agencyComment "//.*$" contains=agencyTodo,@Spell

" ---------------------------------------------------------------------------
" Keywords
" ---------------------------------------------------------------------------
syntax keyword agencyKeyword if while for match return async await throws try
syntax keyword agencyKeyword catch else uses import from tool thread subthread
syntax keyword agencyKeyword safe shared handle with export let const class
syntax keyword agencyKeyword constructor this super parallel seq is

syntax keyword agencyOperatorKeyword typeof instanceof in new delete void

syntax keyword agencyBuiltin input read write fetch fetchJSON fetchJson print
syntax keyword agencyBuiltin llm interrupt approve reject fork propagate

syntax keyword agencyBuiltinType string number boolean void any

syntax keyword agencyConstant null undefined
syntax keyword agencyBoolean  true false

" storage keywords introduce a name; colour the following identifier
syntax keyword agencyStorage def node nextgroup=agencyFunctionName skipwhite
syntax keyword agencyStorage type     nextgroup=agencyTypeName     skipwhite
syntax match   agencyFunctionName contained "\<[a-zA-Z_]\w*\>"
syntax match   agencyTypeName     contained "\<[a-zA-Z_]\w*\>"

" ---------------------------------------------------------------------------
" Types (capitalised identifiers) and function calls
" ---------------------------------------------------------------------------
syntax match agencyType "\<[A-Z]\w*\>"
syntax match agencyFunctionCall "\<[a-zA-Z_]\w*\>\ze\s*("

" ---------------------------------------------------------------------------
" Annotations: @name and @name(...)
" ---------------------------------------------------------------------------
syntax match agencyAnnotation "@[a-zA-Z_]\w*"

" ---------------------------------------------------------------------------
" Lambdas / inline blocks: \x -> expr   and   \(x, y) -> expr
" ---------------------------------------------------------------------------
syntax match agencyLambda "\\\ze[a-zA-Z_(]"

" ---------------------------------------------------------------------------
" Numbers
" ---------------------------------------------------------------------------
syntax match agencyNumber "\<0[xX]\x\+\>"
syntax match agencyNumber "\<0[oO]\o\+\>"
syntax match agencyNumber "\<0[bB][01]\+\>"
syntax match agencyNumber "\<\d\+\.\?\d*\%([eE][+-]\?\d\+\)\?\>"
syntax match agencyNumber "\.\d\+\%([eE][+-]\?\d\+\)\?\>"

" Unit literals (defined after numbers so they take precedence on overlap)
" Cost: $5, $5.00, $0.50
syntax match agencyUnit "\$\d\+\.\?\d*"
" Time: 30s, 500ms, 2h, 1m, 3d, 1w
syntax match agencyUnit "\<\d\+\.\?\d*\%(ms\|[smhdw]\)\>"

" ---------------------------------------------------------------------------
" Operators
" ---------------------------------------------------------------------------
syntax match agencyOperator "\%(::\|=>\|->\|;>\||>\|\.\.\.\|?\.\|??\)"
syntax match agencyOperator "\%(===\|!==\|==\|!=\|<=\|>=\|&&\|||\)"
syntax match agencyOperator "[-+*/%=<>!&|^~?:]"

" ---------------------------------------------------------------------------
" String interpolation + escapes (shared by all string kinds)
" ---------------------------------------------------------------------------
syntax match  agencyEscape contained "\\."
syntax region agencyInterp contained matchgroup=agencyInterpDelim
      \ start="${" end="}" contains=@agencyExpr

" ---------------------------------------------------------------------------
" Strings  (triple before double so """ is not seen as an empty "")
" ---------------------------------------------------------------------------
syntax region agencyTripleString start=+"""+ end=+"""+
      \ contains=agencyInterp,agencyEscape,@Spell
syntax region agencyString start=+"+ skip=+\\.+ end=+"+
      \ contains=agencyInterp,agencyEscape,@Spell
syntax region agencyTemplate start=+`+ skip=+\\.+ end=+`+
      \ contains=agencyInterp,agencyEscape,@Spell

" ---------------------------------------------------------------------------
" Expression cluster — what may appear inside ${ ... } interpolation
" ---------------------------------------------------------------------------
syntax cluster agencyExpr contains=agencyKeyword,agencyOperatorKeyword,
      \agencyBuiltin,agencyBuiltinType,agencyConstant,agencyBoolean,
      \agencyType,agencyFunctionCall,agencyNumber,agencyUnit,agencyOperator,
      \agencyString,agencyTemplate,agencyTripleString,agencyAnnotation

" ---------------------------------------------------------------------------
" Highlight links — map to standard groups so any colorscheme applies
" ---------------------------------------------------------------------------
highlight default link agencyComment         Comment
highlight default link agencyTodo            Todo
highlight default link agencyKeyword         Keyword
highlight default link agencyOperatorKeyword Operator
highlight default link agencyStorage         StorageClass
highlight default link agencyBuiltin         Function
highlight default link agencyBuiltinType     Type
highlight default link agencyConstant        Constant
highlight default link agencyBoolean         Boolean
highlight default link agencyFunctionName    Function
highlight default link agencyFunctionCall    Function
highlight default link agencyTypeName        Type
highlight default link agencyType            Type
highlight default link agencyAnnotation      PreProc
highlight default link agencyLambda          Operator
highlight default link agencyNumber          Number
highlight default link agencyUnit            Number
highlight default link agencyOperator        Operator
highlight default link agencyString          String
highlight default link agencyTemplate        String
highlight default link agencyTripleString    String
highlight default link agencyEscape          SpecialChar
highlight default link agencyInterpDelim     Special

let b:current_syntax = "agency"
