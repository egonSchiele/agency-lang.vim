# agency-lang.vim

Vim/Neovim support for the [Agency language](https://github.com/egonSchiele/agency-lang) (`.agency` files):
syntax highlighting plus optional LSP integration (diagnostics, go-to-definition,
hover, completion) via the `agency lsp` server.

The grammar is ported from the official Agency VS Code extension, so highlighting
stays in sync with the language: comments, single/triple/backtick strings with
`${…}` interpolation, keywords, builtins (`llm`, `fetch`, `print`, …), types,
`@annotations`, lambdas (`\x -> …`), unit literals (`$5`, `30s`, `500ms`),
numbers, and operators.

## Requirements

- Vim 8+ or Neovim (for syntax highlighting)
- Neovim 0.10+ and the `agency` CLI on your `PATH` (for LSP features)

## Installation

This repo is a standard Vim plugin: the `ftdetect/`, `ftplugin/`, `syntax/`, and
`lua/` directories live at its root, so any plugin manager or Vim's native
packaging will pick them up.

### vim-plug

```vim
Plug 'egonSchiele/agency-lang.vim'
```

Then `:PlugInstall`.

### lazy.nvim

```lua
{ 'egonSchiele/agency-lang.vim' }
```

### packer.nvim

```lua
use 'egonSchiele/agency-lang.vim'
```

### Vim 8+ / Neovim native packages (no plugin manager)

```bash
# Vim
git clone https://github.com/egonSchiele/agency-lang.vim \
  ~/.vim/pack/plugins/start/agency-lang.vim

# Neovim
git clone https://github.com/egonSchiele/agency-lang.vim \
  ~/.config/nvim/pack/plugins/start/agency-lang.vim
```

### Manual

Copy the directories into your runtime path, preserving the layout:

```bash
# Vim
cp -r ftdetect ftplugin syntax ~/.vim/

# Neovim
cp -r ftdetect ftplugin syntax lua ~/.config/nvim/
```

Make sure your config enables syntax and filetype plugins:

```vim
syntax on
filetype plugin on
```

Open any `.agency` file and it will be highlighted.

## LSP setup (optional)

Syntax highlighting works on its own. For diagnostics, go-to-definition, hover,
and completion, connect the `agency lsp` server to a Vim LSP client.

However it is started, the server's launch command is auto-detected, trying in
order: **`agency`**, then **`pnpm agency`**, then **`npm agency`** — the first
one available wins. Override it by setting (in your `vimrc`):

```vim
let g:agency_lsp_cmd = ['pnpm', 'run', '--silent', 'agency', 'lsp']
```

### Regular Vim (Vim 8+) — via vim-lsp

Plain Vim has no built-in LSP client, so you need one plugin:
[vim-lsp](https://github.com/prabirshrestha/vim-lsp) (pure VimScript, no Node
required) plus its dependency [async.vim](https://github.com/prabirshrestha/async.vim).

1. Install them alongside this plugin. With vim-plug:

   ```vim
   Plug 'prabirshrestha/async.vim'
   Plug 'prabirshrestha/vim-lsp'
   Plug 'egonSchiele/agency-lang.vim'
   ```

   Then `:PlugInstall`.

2. That's it — **no further config needed**. This plugin auto-registers the
   Agency server with vim-lsp as soon as vim-lsp is present, using the
   auto-detected command above. Open a `.agency` file in a project and the
   server attaches.

3. (Optional) add some LSP keybindings to your `vimrc`:

   ```vim
   function! s:on_lsp_buffer_enabled() abort
     setlocal omnifunc=lsp#complete
     nmap <buffer> gd <plug>(lsp-definition)
     nmap <buffer> K  <plug>(lsp-hover)
     nmap <buffer> <leader>e <plug>(lsp-document-diagnostics)
   endfunction

   augroup agency_lsp_keys
     autocmd!
     autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
   augroup END
   ```

To opt out of the auto-registration (e.g. to configure it yourself), set
`let g:agency_lsp_no_vimlsp = 1`.

Check it is running with `:LspStatus` while a `.agency` file is open.

> Other VimScript LSP clients (ALE, LanguageClient-neovim) work too — point their
> server command at `agency#lsp#cmd()` (or your `g:agency_lsp_cmd`).

### Neovim (built-in LSP)

This plugin ships a Lua helper. Add to your config:

```lua
require('agency-lang.lsp').setup()
```

That auto-detects the command and launches the server on any `.agency` buffer.
Override or extend it:

```lua
require('agency-lang.lsp').setup({
  cmd = { 'pnpm', 'run', '--silent', 'agency', 'lsp' }, -- override auto-detect
  root_markers = { 'agency.json', '.git' },             -- how the root is found
  on_attach = function(client, bufnr)                   -- optional: your keymaps
    local opts = { buffer = bufnr }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K',  vim.lsp.buf.hover, opts)
  end,
})
```

### coc.nvim

Add to `:CocConfig`:

```json
{
  "languageserver": {
    "agency": {
      "command": "agency",
      "args": ["lsp"],
      "filetypes": ["agency"],
      "rootPatterns": ["agency.json", ".git"]
    }
  }
}
```

## Notes

- The launch command is auto-detected as `agency` → `pnpm agency` → `npm agency`.
  Override it with `g:agency_lsp_cmd` (Vim) or the `cmd` option (Neovim).
- The command must invoke the server so it speaks JSON-RPC over **stdio**. If you
  route it through `pnpm run`, add `--silent` (`pnpm run --silent agency lsp`) so
  pnpm's header output doesn't corrupt the protocol stream.
- Syntax highlighting and LSP are independent — highlighting works even if the
  server isn't installed.

## License

MIT
