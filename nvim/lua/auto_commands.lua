--https://github.com/brainfucksec/neovim-lua
local augroup=vim.api.nvim_create_augroup
local autocmd=vim.api.nvim_create_autocmd

augroup('YankHighlight',{clear=true,})
augroup('setIndent',{clear=true,})

--Don't auto-comment new lines
autocmd('BufEnter',{
  command='set fo-=c fo-=o fo-=r',
  pattern='*'
})

--Close terminal buffer on process exit
autocmd('BufLeave',{
  command='stopinsert',
  pattern='term://*',
})

--Remove whitespaces on saving
autocmd('BufWritePre',{
  command=':%s/\\s\\+$//e',
  pattern='*',
})

--Open a terminal on the right pane
autocmd('CmdlineEnter',{
  command='command! Term :botright vsplit term://$SHELL',
})

autocmd('FileType',{
  command='setlocal shiftwidth=2 softtabstop=2 tabstop=2',
  group='setIndent',
  pattern={'json','lua','r','sh','vim','zsh',},
})

autocmd('FileType',{
  command='syntax match Comment +\\/\\/.\\+$+',
  pattern='json',
})

autocmd('TermOpen',{
  command='setlocal listchars= nocursorline nonumber norelativenumber',
})

--Enter insert mode when switching to a terminal
autocmd('TermOpen',{
  command='startinsert',
  pattern='*',
})

autocmd('TextYankPost',{
  callback=function()
    vim.highlight.on_yank({higroup='IncSearch',timeout='1000',})
  end,
  group='YankHighlight',
})
