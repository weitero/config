local devicons=require('nvim-web-devicons')
local lualine_theme_vscode=require('lualine.themes.vscode')
local navic=require('nvim-navic')
local vi_mode=require('feline.providers.vi_mode')

navic.setup{
  icons={
    Array=' ',
    Boolean=' ',
    Class=' ',
    Constant=' ',
    Constructor=' ',
    Enum=' ',
    EnumMember=' ',
    Event=' ',
    Field=' ',
    File=' ',
    Function=' ',
    Interface=' ',
    Key=' ',
    Method=' ',
    Module=' ',
    Namespace=' ',
    Null='ﳠ ',
    Number=' ',
    Object=' ',
    Operator=' ',
    Package=' ',
    Property=' ',
    String=' ',
    Struct=' ',
    TypeParameter=' ',
    Variable=' ',
  },
  highlight=false,
  separator=' > ',
  depth_limit=0,
  depth_limit_indicator='..',
  safe_output=true,
}

local diagnostics_exist=function()
  return require('feline.providers.lsp').diagnostics_exist()
end

local git_exists=function()
  return require('feline.providers.git').git_info_exists()
end

local statusline_components={active={{},{},{},},inactive={{},{},{},},}
local winbar_components={active={{},{},{},},inactive={{},{},{},},}

statusline_components.active[1][1]={
  provider={name='vi_mode',opts={show_mode_name=true,},},
  hl=function()
    return {
      bg=vi_mode.get_mode_color(),
      name=vi_mode.get_mode_highlight_name(),
      style='bold',
    }
  end,
  icon=' ',
  left_sep='block',
  right_sep='block',
}

statusline_components.active[1][2]={
  provider={
    name='file_info',
    opts={
      file_modified_icon='[+] ',
      file_readonly_icon=' ',
      type='unique',
    },
  },
  hl=function()
    return {fg=vi_mode.get_mode_color(),}
  end,
  icon='',
  left_sep='block',
}

statusline_components.active[2][1]={
  provider='git_branch',
  enabled=git_exists,
  hl={bg='#f1502f',},
  left_sep='block',
  right_sep={str='block',hl={bg='#3e2c00',fg='#f1502f',},},
}
statusline_components.active[2][2]={
  provider='git_diff_added',
  enabled=git_exists,
  hl={bg='#3e2c00',fg='#f1502f',},
}
statusline_components.active[2][3]={
  provider='git_diff_changed',
  enabled=git_exists,
  hl={bg='#3e2c00',fg='#f1502f',},
}
statusline_components.active[2][4]={
  provider='git_diff_removed',
  enabled=git_exists,
  hl={bg='#3e2c00',fg='#f1502f',},
  right_sep={str='block',always_visible=true,hl={fg='#3e2c00',},},
}

statusline_components.active[2][5]={
  provider='lsp_client_names',
  enabled=diagnostics_exist,
  hl={bg='#194efb',},
  left_sep={str='block',always_visible=true,},
  right_sep={str='block',always_visible=true,},
}
statusline_components.active[2][6]={provider='diagnostic_errors',}
statusline_components.active[2][7]={provider='diagnostic_warnings',}
statusline_components.active[2][8]={provider='diagnostic_hints',}
statusline_components.active[2][9]={provider='diagnostic_info',}

statusline_components.active[3][1]={
  provider={name='position',opts={format=' {line}  {col}',},},
  hl=function()
    local _,icon_color=devicons.get_icon_color(
    vim.fn.expand('%:t'),nil,{default=true,})
    return {bg=icon_color,}
  end,
  left_sep={
    str='block',
    hl=function()
      local _,icon_color=devicons.get_icon_color(
      vim.fn.expand('%:t'),nil,{default=true,})
      return {
        bg=lualine_theme_vscode.normal.b.bg,
        fg=icon_color,
      }
    end,
  },
}
statusline_components.active[3][2]={
  provider='line_percentage',
  hl=function()
    local _,icon_color=devicons.get_icon_color(
    vim.fn.expand('%:t'),nil,{default=true,})
    return {bg=icon_color,}
  end,
  left_sep={
    str=' ﴜ ',
    hl=function()
      local _,icon_color=devicons.get_icon_color(
      vim.fn.expand('%:t'),nil,{default=true,})
      return {bg=icon_color,}
    end,
  },
  right_sep='block',
}

winbar_components.active[1][1]={
  provider=function()
    return navic.get_location()
  end,
  enabled=function()
    return navic.is_available()
  end,
}

winbar_components.active[3][1]={
  provider={
    name='file_type',
    opts={case='uppercase',colored_icon=false,filetype_icon=true,},
  },
}
winbar_components.active[3][2]={
  provider='file_encoding',
  left_sep={str='',hl={fg=lualine_theme_vscode.normal.b.bg,},},
}

require('feline').setup({
  components=statusline_components,
  theme={
    bg=require('vscode.colors').get_colors().vscBack,
    fg=require('vscode.colors').get_colors().vscFront,
  },
})

require('feline').winbar.setup({components=winbar_components,})
