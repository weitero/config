local dap=require('dap')
local dapui=require('dapui')

--Adapters
dap.adapters.python={
  type='executable',
  command='/usr/local/bin/python3',
  args={'-m','debugpy.adapter',},
}

--Configurations
dap.configurations.python={
  {
    --The first three options are required by nvim-dap
    type='python',
    request='launch',
    name='Launch file',
    --Options below are for debugpy
    program='${file}',
    pythonPath='/usr/local/bin/python3',
  },
}

dapui.setup({
  icons={expanded=' ',collapsed='',current_frame=' ',},
  mappings={
    --Use a table to apply multiple mappings
    expand={'<cr>','<2-LeftMouse>',},
    open='o',
    remove='d',
    edit='e',
    repl='r',
    toggle='t',
  },
  --Use this to override mappings for specific elements
  element_mappings={
    stacks={
      open='<cr>',
      expand='o',
    },
  },
  --Expand lines larger than the window
  expand_lines=vim.fn.has('nvim-0.7')==1,
  --Layouts define sections of the screen to place windows.
  --The position can be 'left', 'right', 'top' or 'bottom'.
  --The size specifies the height/width depending on position. It can be
  --an Int or a Float. Integer specifies height/width directly
  --(i.e. 20 lines/columns) while Float value specifies percentage
  --(i.e. 0.3 - 30% of available lines/columns)
  --Elements are the elements shown in the layout (in order).
  --Layouts are opened in order so that earlier layouts take priority
  --in window sizing.
  layouts={
    {
      elements={
        --Elements can be strings or table with id and size keys.
        {id='scopes',size=0.25,},
        'breakpoints',
        'stacks',
        'watches',
      },
      size=40, --40 columns
      position='left',
    },
    {
      elements={
        'repl',
        'console',
      },
      size=0.25, --25% of total lines
      position='bottom',
    },
  },
  controls={
    --Requires Neovim nightly (or 0.8 when released)
    enabled=true,
    --Display controls in this element
    element='repl',
    icons={
      pause='',
      play='',
      step_into='',
      step_over=' ',
      step_out='',
      step_back=' ',
      run_last=' ',
      terminate=' ',
    },
  },
  floating={
    max_height=nil,
    max_width=nil,
    border='rounded',
    mappings={close={'q','<esc>',},},
  },
  windows={indent=1,},
  render={
    max_type_length=nil,
    max_value_lines=100,
  },
})

dap.listeners.after.event_initialized['dapui_config']=function()
  dapui.open()
end
dap.listeners.before.event_terminated['dapui_config']=function()
  dapui.close()
end
dap.listeners.before.event_exited['dapui_config']=function()
  dapui.close()
end

require('nvim-dap-virtual-text').setup{
  enabled=true,
  enabled_commands=true,
  highlight_changed_variables=true,
  highlight_new_as_changed=false,
  show_stop_reason=true,
  commented=false,
  only_first_definition=true,
  all_references=false,
  filter_references_pattern='<module>',
  --experimental features:
  virt_text_pos='eol',
  all_frames=false,
  virt_lines=false,
  virt_text_win_col=nil,
}
