local map=vim.keymap.set
map('n','<c-h>','<c-w>h',{remap=false,})
map('n','<c-j>','<c-w>j',{remap=false,})
map('n','<c-k>','<c-w>k',{remap=false,})
map('n','<c-l>','<c-w>l',{remap=false,})
map({'n','v',},'j','gj')
map({'n','v',},'k','gk')
