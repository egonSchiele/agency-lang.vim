" Agency language filetype plugin
if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

" Comments: // line, /* block */
setlocal commentstring=//\ %s
setlocal comments=s1:/*,mb:*,ex:*/,://

" Treat identifier-ish characters as part of a word
setlocal iskeyword+=_

let b:undo_ftplugin = "setlocal commentstring< comments< iskeyword<"
