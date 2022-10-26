local components={active={{},{},{},},inactive={{},{},{},},}
local devicons=require('nvim-web-devicons')
local lualine_theme_vscode=require('lualine.themes.vscode')
local vi_mode=require('feline.providers.vi_mode')

local git_exists=function()return require('feline.providers.git').git_info_exists()end
local diagnostics_exist=function()return require('feline.providers.lsp').diagnostics_exist()end

local osicons={
  darwin=' ',
  linux=' ',
  windows=' ',
}
--https://github.com/6cdh/dotfiles/blob/62959d27344dade28d6dd638252cd82accb309ab/nvim/.config/nvim/lua/statusline.lua
--https://www.reddit.com/r/neovim/comments/pc7in0/detect_os_in_lua/
local function osinfo()
  local os=vim.loop.os_uname().sysname
  local icon
  if os=='Darwin' then
    icon=osicons.darwin
  elseif os=='Linux' then
    icon=osicons.linux
  else
    icon=osicons.windows
  end
  return icon
end

components.active[1][1]={
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
  right_sep={
    str='right_rounded',
    hl=function()
      return {
        bg=lualine_theme_vscode.normal.c.bg,
        fg=vi_mode.get_mode_color(),
      }
    end,
  },
}
components.active[1][2]={
  provider={
    name='file_info',
    opts={
      file_modified_icon=' ',
      file_readonly_icon=' ', --uf720
      type='unique',
    },
  },
  hl=function()
    return {fg=vi_mode.get_mode_color(),}
  end,
  icon='',
}

components.active[2][1]={
  provider='git_branch',
  enabled=git_exists,
  hl={bg='#f1502f',},
  left_sep='left_rounded',
  right_sep={str='right_rounded',hl={bg='#3e2c00',fg='#f1502f',},},
}
components.active[2][2]={
  provider='git_diff_added',
  enabled=git_exists,
  hl={bg='#3e2c00',fg='#f1502f',},
}
components.active[2][3]={
  provider='git_diff_changed',
  enabled=git_exists,
  hl={bg='#3e2c00',fg='#f1502f',},
}
components.active[2][4]={
  provider='git_diff_removed',
  enabled=git_exists,
  hl={bg='#3e2c00',fg='#f1502f',},
  right_sep={str='right_rounded',always_visible=true,hl={fg='#3e2c00',},},
}

components.active[2][5]={
  provider='lsp_client_names',
  enabled=diagnostics_exist,
  hl={bg='#194efb',},
  left_sep={str='left_rounded',always_visible=true,},
  right_sep={str='right_rounded',always_visible=true,},
}
components.active[2][6]={provider='diagnostic_errors',}
components.active[2][7]={provider='diagnostic_warnings',}
components.active[2][8]={provider='diagnostic_hints',}
components.active[2][9]={provider='diagnostic_info',}

components.active[3][1]={
  provider={
    name='file_type',
    opts={case='uppercase',colored_icon=true,filetype_icon=true,},
  },
  left_sep='left_rounded',
}
components.active[3][2]={
  provider='file_encoding',
  hl={bg=lualine_theme_vscode.normal.b.bg,},
  left_sep={
    str='left_rounded',
    hl={
      bg=lualine_theme_vscode.normal.c.bg,
      fg=lualine_theme_vscode.normal.b.bg,
    },
  },
}
components.active[3][3]={
  provider=osinfo,
  hl={bg=lualine_theme_vscode.normal.b.bg,},
  left_sep={
    str=' ',
    hl={bg=lualine_theme_vscode.normal.b.bg,},
  },
}
components.active[3][4]={
  provider={
    name='position',
    opts={format=' {line}  {col}',}, --ue0a1,ue0a3
  },
  hl=function()
    local _,icon_color=devicons.get_icon_color(vim.fn.expand('%:t'),nil,{default=true,})
    return {bg=icon_color,}
  end,
  left_sep={
    str='left_rounded',
    hl=function()
      local _,icon_color=devicons.get_icon_color(vim.fn.expand('%:t'),nil,{default=true,})
      return {
        bg=lualine_theme_vscode.normal.b.bg,
        fg=icon_color,
      }
    end,
  },
}
components.active[3][5]={
  provider='line_percentage',
  hl=function()
    local _,icon_color=devicons.get_icon_color(vim.fn.expand('%:t'),nil,{default=true,})
    return {bg=icon_color,}
  end,
  left_sep={
    str=' ﴜ ',
    hl=function()
      local _,icon_color=devicons.get_icon_color(vim.fn.expand('%:t'),nil,{default=true,})
      return {bg=icon_color,}
    end,
  },
  right_sep='block',
}

require('feline').setup({
  components=components,
  theme={
    bg=require('vscode.colors').vscBack,
    fg=require('vscode.colors').vscFront,
  },
})
