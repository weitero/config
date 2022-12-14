local fh=assert(io.popen('defaults read -g AppleInterfaceStyle 2>/dev/null','r'))
local theme=assert(fh:read('*a'))
fh:close()
if theme=='Dark\n' then
  vim.opt.background='dark'
else
  vim.opt.background='light'
end
require('vscode').setup({italic_comments=true,disable_nvimtree_bg=true,})

require('alpha').setup(require('alpha.themes.startify').config)
require('colorizer').setup()
require('nvim-tree').setup({filters={dotfiles=false,},})
require('treesitter-context').setup{enable=true,separator='',}

require('indent_blankline').setup{
  show_current_context=true,
  show_current_context_start=true,
  show_end_of_line=true,
  space_char_blankline=' ',
  use_treesitter=false,
}

require('nvim_comment').setup{
  comment_chunk_text_object='ic',
  comment_empty=true,
  comment_empty_trim_whitespace=true,
  create_mappings=true,
  hook=nil,
  line_mapping='gcc',
  marker_padding=true,
  operator_mappings='gc',
}

vim.api.nvim_win_set_option(
0,'winhighlight','NormalFloat:Normal,FloatBorder:Normal')
