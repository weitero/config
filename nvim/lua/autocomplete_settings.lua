local cmp=require('cmp')
local luasnip=require('luasnip')

local has_words_before=function()
  local line,col=unpack(vim.api.nvim_win_get_cursor(0))
  return col~=0 and vim.api.nvim_buf_get_lines(0,line-1,line,true)[1]:sub(col,col):match('%s')==nil
end

local kind_icons={
  Class=' ',
  Color=' ',
  Constant=' ',
  Constructor=' ',
  Enum=' ',
  EnumMember=' ',
  Event=' ',
  Field=' ',
  File=' ',
  Folder=' ',
  Function=' ',
  Interface=' ',
  Keyword=' ',
  Method=' ',
  Module=' ',
  Operator=' ',
  Property=' ',
  Reference=' ',
  Snippet=' ',
  Struct=' ',
  Text=' ',
  TypeParameter=' ',
  Unit=' ',
  Value=' ',
  Variable=' ',
}

cmp.setup({
  experimental={ghost_text=true,},
  formatting={format=function(entry,vim_item)
    vim_item.kind=string.format(
    '%s %s',kind_icons[vim_item.kind],vim_item.kind)
    vim_item.menu=({
      buffer='[Buffer]',
      nvim_lsp='[LSP]',
      luasnip='[LuaSnip]',
      nvim_lua='[Lua]',
      latex_symbols='[LaTeX]',
    })[entry.source.name]
    return vim_item
  end,},
  mapping={
    ['<cr>']=cmp.mapping.confirm({select=false,}),
    ['<down>']=cmp.mapping.scroll_docs(4),
    ['<s-tab>']=cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end,{'i','s',}),
    ['<tab>']=cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end,{'i','s',}),
    ['<up>']=cmp.mapping.scroll_docs(-4),
  },
  snippet={
    expand=function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  sources=cmp.config.sources({
    {name='nvim_lsp',},
    {name='luasnip',},
    {name='buffer',},
    {name='path',},
    {name='nvim_lua',},
  }),
  view={entries={name='custom',selection_order='near_cursor',},},
  window={
    completion=cmp.config.window.bordered(),
    documentation=cmp.config.window.bordered(),
  },
})

cmp.event:on('confirm_done',
require('nvim-autopairs.completion.cmp').on_confirm_done())

cmp.setup.cmdline('/',
{view={entries={name='wildmenu',separator='|',},},})
