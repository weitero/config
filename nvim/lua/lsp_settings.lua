local lspconfig=require('lspconfig')
local map=vim.keymap.set
local navic=require('nvim-navic')

--Use a `on_attach` function to only map the following keys after the language server attaches to the current buffer
local on_attach=function(client,bufnr)
  local bufopts={buffer=bufnr,noremap=true,silent=true,}
  map('n','<space>D',vim.lsp.buf.type_definition,bufopts)
  map('n','<space>ca',vim.lsp.buf.code_action,bufopts)
  map('n','<space>f',function()
    vim.lsp.buf.format{async=true,}
  end,bufopts)
  map('n','<space>rn',vim.lsp.buf.rename,bufopts)
  map('n','K',vim.lsp.buf.hover,bufopts)
  map('n','gD',vim.lsp.buf.declaration,bufopts)
  map('n','gd',vim.lsp.buf.definition,bufopts)
  map('n','gi',vim.lsp.buf.implementation,bufopts)
  map('n','gr',vim.lsp.buf.references,bufopts)

  --Highlight symbol under cursor
  if client.server_capabilities.documentHighlightProvider then
    vim.api.nvim_create_augroup('lsp_document_highlight',{clear=false,})
    vim.api.nvim_clear_autocmds({
      buffer=bufnr,
      group='lsp_document_highlight',
    })
    vim.api.nvim_create_autocmd({'CursorHold','CursorHoldI',},
    {
      buffer=bufnr,
      callback=vim.lsp.buf.document_highlight,
      group='lsp_document_highlight',
    })
    vim.api.nvim_create_autocmd({'CursorMoved','CursorMovedI',},
    {
      buffer=bufnr,
      callback=vim.lsp.buf.clear_references,
      group='lsp_document_highlight',
    })
  end

  --Wrap nvim-navic's `attach` function to make sure `documentSymbolProvider` is enabled
  if client.server_capabilities.documentSymbolProvider then
    navic.attach(client,bufnr)
  end
end

local capabilities=vim.lsp.protocol.make_client_capabilities()
capabilities=require('cmp_nvim_lsp').default_capabilities(capabilities)

lspconfig['awk_ls'].setup{on_attach=on_attach,}
lspconfig['bashls'].setup{on_attach=on_attach,}
lspconfig['clangd'].setup{on_attach=on_attach,}
lspconfig['dotls'].setup{on_attach=on_attach,}
lspconfig['jsonls'].setup{on_attach=on_attach,}
lspconfig['r_language_server'].setup{on_attach=on_attach,}
lspconfig['vimls'].setup{on_attach=on_attach,}

lspconfig['perlnavigator'].setup{
  cmd={'node',os.getenv('HOME')..'/software/git/PerlNavigator/server/out/server.js','--stdio',},
  on_attach=on_attach,
  settings={perlnavigator={perlPath='/usr/bin/perl',},},
}

lspconfig['pyright'].setup{
  capabilities=capabilities,
  on_attach=on_attach,
}

lspconfig['sumneko_lua'].setup{
  on_attach=on_attach,
  settings={
    Lua={
      diagnostics={globals={'bufnr','vim',},},
      telemetry={enable=false,},
    },
  },
}
