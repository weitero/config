require('hop').setup{
  create_hl_autocmd=false,
}
local map=vim.keymap.set
map('','//',':HopPattern<cr>',{})
map('','<leader>F',':HopChar2<cr>',{})
map('','<leader>f',':HopChar1<cr>',{})
map('','<leader>l',':HopLine<cr>',{})
map('','<leader>w',':HopWord<cr>',{})
