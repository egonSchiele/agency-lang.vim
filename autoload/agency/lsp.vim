" Shared LSP helpers for the Agency language.

" Returns the command (as a list) used to launch the `agency lsp` server.
" Tries, in order: `agency`, then `pnpm agency`, then `npm agency`.
" Override entirely by setting g:agency_lsp_cmd to a list, e.g.
"   let g:agency_lsp_cmd = ['pnpm', 'run', '--silent', 'agency', 'lsp']
function! agency#lsp#cmd() abort
  if exists('g:agency_lsp_cmd')
    return g:agency_lsp_cmd
  endif
  if executable('agency')
    return ['agency', 'lsp']
  elseif executable('pnpm')
    return ['pnpm', 'agency', 'lsp']
  elseif executable('npm')
    return ['npm', 'agency', 'lsp']
  endif
  return []
endfunction

" Registers the Agency server with vim-lsp. Safe to call only when vim-lsp is
" loaded (it is wired to the `User lsp_setup` event by plugin/agency_lsp.vim).
function! agency#lsp#register_vimlsp() abort
  let l:cmd = agency#lsp#cmd()
  if empty(l:cmd)
    return
  endif
  call lsp#register_server({
    \ 'name': 'agency',
    \ 'cmd': {server_info->l:cmd},
    \ 'allowlist': ['agency'],
    \ 'root_uri': {server_info->lsp#utils#path_to_uri(
    \     lsp#utils#find_nearest_parent_file_directory(
    \       lsp#utils#get_buffer_path(), ['agency.json', '.git/']))},
    \ })
endfunction
