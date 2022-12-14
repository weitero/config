local map=vim.keymap.set
map('n','<space>e',vim.diagnostic.open_float,{noremap=true,silent=true,})
map('n','<space>q',vim.diagnostic.setloclist,{noremap=true,silent=true,})
map('n','[d',vim.diagnostic.goto_prev,{noremap=true,silent=true,})
map('n',']d',vim.diagnostic.goto_next,{noremap=true,silent=true,})

vim.diagnostic.config({
  float={
    border='rounded',
    close_events={
      'BufLeave',
      'CursorMoved',
      'FocusLost',
      'InsertEnter',
    },
    focus=false,
    focusable=false,
    scope='cursor',
    source='always',
  },
  serverity_sort=true,
  signs=true,
  underline=true,
  update_in_insert=true,
  virtual_text=true,
})

local signs={
  Error=' ',
  Hint='ﴕ ',
  Info='',
  Warn=' ',
}
for type_,icon in pairs(signs) do
  local hl='DiagnosticSign'..type_
  vim.fn.sign_define(hl,{text=icon,texthl=hl,numhl=hl,})
end
