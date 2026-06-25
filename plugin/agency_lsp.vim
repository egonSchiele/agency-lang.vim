" Auto-register the Agency LSP server with vim-lsp, when vim-lsp is installed.
"
" If you don't use vim-lsp, the `User lsp_setup` event never fires and this does
" nothing. To opt out even with vim-lsp installed:
"   let g:agency_lsp_no_vimlsp = 1
if exists('g:loaded_agency_lsp')
  finish
endif
let g:loaded_agency_lsp = 1

if get(g:, 'agency_lsp_no_vimlsp', 0)
  finish
endif

augroup agency_lsp_register
  autocmd!
  autocmd User lsp_setup call agency#lsp#register_vimlsp()
augroup END
