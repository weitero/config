require('leap').add_default_mappings()
require('luasnip.loaders.from_vscode').lazy_load()
require('nvim-surround').setup()

require('nvim-autopairs').setup({
  disable_filetype={'TelescopePrompt','vim',},
  enable_check_bracket_line=false,
  fast_wrap={},
})

require('nvim-treesitter.configs').setup{
  auto_install=true,
  ensure_installed={'python',},
  highlight={enable=true,},
  sync_install=true,
}
