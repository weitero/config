--https://github.com/brainfucksec/neovim-lua/blob/main/nvim/lua/core/autocmds.lua
local augroup=vim.api.nvim_create_augroup
local autocmd=vim.api.nvim_create_autocmd

augroup('YankHighlight',{clear=true,})
augroup('setIndent',{clear=true,})
autocmd('BufEnter',{command='set fo-=c fo-=o fo-=r',pattern='*',}) --Don't auto-comment new lines
autocmd('BufLeave',{command='stopinsert',pattern='term://*',}) --Close terminal buffer on process exit
autocmd('BufWritePre',{command=':%s/\\s\\+$//e',pattern='*',}) --Remove whitespaces on saving
autocmd('CmdlineEnter',{command='command! Term :botright vsplit term://$SHELL',}) --Open a terminal on the right pane
autocmd('FileType',{command='setlocal shiftwidth=2 softtabstop=2 tabstop=2',group='setIndent',pattern={'json','lua','r','sh','vim','zsh',},})
autocmd('FileType',{command='syntax match Comment +\\/\\/.\\+$+',pattern='json',})
autocmd('TermOpen',{command='setlocal listchars= nocursorline nonumber norelativenumber',})
autocmd('TermOpen',{command='startinsert',pattern='*',}) --Enter insert mode when switching to a terminal
autocmd('TextYankPost',{callback=function()vim.highlight.on_yank({higroup='IncSearch',timeout='1000',})end,group='YankHighlight',})
