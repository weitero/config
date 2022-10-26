local fh=assert(io.popen('defaults read -g AppleInterfaceStyle 2>/dev/null','r'))
local theme=assert(fh:read('*a'))
fh:close()

if theme=='Dark\n' then vim.opt.background='dark' else vim.opt.background='light'end
require('vscode').setup({italic_comments=true,disable_nvimtree_bg=true,})

vim.diagnostic.config({
  float={source='always',},
  serverity_sort=true,
  signs=true,
  underline=true,
  update_in_insert=true,
  virtual_text=true,
})
