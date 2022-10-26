require('lspsaga').init_lsp_saga({
  border_style='rounded',
})

local map=vim.keymap.set
map('n','<leader>cd','<cmd>Lspsaga show_cursor_diagnostics<cr>',{silent=true,})
map('n','<leader>ld','<cmd>Lspsaga show_line_diagnostics<cr>',{silent=true,})
map('n','K','<cmd>Lspsaga hover_doc<cr>',{silent=true,})
map('n','[e','<cmd>Lspsaga diagnostic_jump_prev<cr>',{silent=true,})
map('n',']e','<cmd>Lspsaga diagnostic_jump_next<cr>',{silent=true,})
map('n','gd','<cmd>Lspsaga peek_definition<cr>',{silent=true,})
map('n','gh','<cmd>Lspsaga lsp_finder<cr>',{silent=true,})
map('n','gr','<cmd>Lspsaga rename<cr>',{silent=true,})
map({'n','v',},'<leader>ca','<cmd>Lspsaga code_action<cr>',{silent=true,})
