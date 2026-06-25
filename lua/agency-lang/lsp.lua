-- Neovim LSP integration for the Agency language.
--
-- Requires Neovim 0.10+ (uses vim.fs.root and vim.lsp.start).
-- It connects to the `agency lsp` server over stdio — the same server the
-- VS Code extension uses.
--
-- Usage (anywhere in your Neovim config):
--
--     require('agency-lang.lsp').setup()
--
-- By default the command is auto-detected, trying in order:
--   `agency`, then `pnpm agency`, then `npm agency`.
-- Override it if needed, e.g. when running it through pnpm inside a project:
--
--     require('agency-lang.lsp').setup({
--       cmd = { 'pnpm', 'run', '--silent', 'agency', 'lsp' },
--     })

local M = {}

-- Pick the launch command, trying `agency`, then `pnpm agency`, then `npm agency`.
local function detect_cmd()
  if vim.fn.executable('agency') == 1 then
    return { 'agency', 'lsp' }
  elseif vim.fn.executable('pnpm') == 1 then
    return { 'pnpm', 'agency', 'lsp' }
  elseif vim.fn.executable('npm') == 1 then
    return { 'npm', 'agency', 'lsp' }
  end
  return { 'agency', 'lsp' }
end

local defaults = {
  -- How to launch the LSP server. It must speak JSON-RPC over stdio.
  -- nil = auto-detect (see detect_cmd above).
  cmd = nil,
  -- Files/dirs that mark the project root, nearest-first.
  root_markers = { 'agency.json', '.git' },
  -- Called with the LSP client and buffer after the server attaches.
  -- Use it to set buffer-local keymaps, etc. Optional.
  on_attach = nil,
}

function M.setup(opts)
  opts = vim.tbl_deep_extend('force', defaults, opts or {})
  opts.cmd = opts.cmd or detect_cmd()

  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'agency',
    group = vim.api.nvim_create_augroup('AgencyLsp', { clear = true }),
    callback = function(args)
      local root_dir = vim.fs.root(args.buf, opts.root_markers)
        or vim.fs.dirname(vim.api.nvim_buf_get_name(args.buf))

      vim.lsp.start({
        name = 'agency',
        cmd = opts.cmd,
        root_dir = root_dir,
        on_attach = opts.on_attach,
      })
    end,
  })
end

return M
