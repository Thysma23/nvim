require("nvchad.configs.lspconfig").defaults()

-- Configure Deno LSP
vim.lsp.config('denols', {
  cmd = { 'deno', 'lsp' },
  root_markers = { 'deno.json', 'deno.jsonc' },
  filetypes = { 'javascript', 'javascriptreact', 'javascript.jsx', 'typescript', 'typescriptreact', 'typescript.tsx' },
  default_config = {
    init_options = {
      enable = true,
      lint = true,
      unstable = true,
      documentFormatting = true,
    },
  },
})

local servers = { "denols", "lua_ls", "dockerls" }
vim.lsp.enable(servers)

-- read :h vim.lsp.config for changing options of lsp servers
