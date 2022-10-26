local lspconfig=require('lspconfig')
local map=vim.keymap.set

-- local capabilities=vim.lsp.protocol.make_client_capabilities()
-- capabilities=require('cmp_nvim_lsp').update_capabilities(capabilities)

lspconfig['awk_ls'].setup{}
lspconfig['bashls'].setup{}
lspconfig['dotls'].setup{}
lspconfig['jsonls'].setup{}
lspconfig['perlnavigator'].setup{cmd={'node',os.getenv('HOME')..'/software/git/PerlNavigator/server/out/server.js','--stdio',},settings={perlnavigator={perlPath='/usr/bin/perl',},},}
lspconfig['pyright'].setup{}
lspconfig['r_language_server'].setup{}
lspconfig['sumneko_lua'].setup{settings={Lua={diagnostics={globals={'vim','bufnr',},},telemetry={enable=false,},},},}
lspconfig['vimls'].setup{}

map('n','<space>D',vim.lsp.buf.type_definition,{buffer=bufnr,noremap=true,silent=true,})
map('n','<space>e',vim.diagnostic.open_float,{noremap=true,silent=true,})
map('n','<space>q',vim.diagnostic.setloclist,{noremap=true,silent=true,})
map('n','<space>rn',vim.lsp.buf.rename,{buffer=bufnr,noremap=true,silent=true,})
map('n','K',vim.lsp.buf.hover,{buffer=bufnr,noremap=true,silent=true,})
map('n','[d',vim.diagnostic.goto_prev,{noremap=true,silent=true,})
map('n',']d',vim.diagnostic.goto_next,{noremap=true,silent=true,})
map('n','gD',vim.lsp.buf.declaration,{buffer=bufnr,noremap=true,silent=true,})
map('n','gd',vim.lsp.buf.definition,{buffer=bufnr,noremap=true,silent=true,})
map('n','gi',vim.lsp.buf.implementation,{buffer=bufnr,noremap=true,silent=true,})
map('n','gr',vim.lsp.buf.references,{buffer=bufnr,noremap=true,silent=true,})
