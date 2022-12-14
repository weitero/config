--https://github.com/glepnir/lspsaga.nvim
local code_action_icon='💡'
local code_action_lightbulb_config={
  enable=true,
  enable_in_insert=true,
  sign=false,
  sign_priority=40,
  update_time=150,
  virtual_text=true,
}
local code_action_method='textDocument/codeAction'

local SIGN_GROUP='sagalightbulb'
local SIGN_NAME='LspSagaLightBulb'
local hl_group='LspSagaLightBulb'
local timer=vim.loop.new_timer()

local buf_auid={}
local lb={}
local server_filetype_map={}

if vim.tbl_isempty(vim.fn.sign_getdefined(SIGN_NAME)) then
  vim.fn.sign_define(SIGN_NAME,{text=code_action_icon,texthl=hl_group,})
end

local has_value=function(filetypes,val)
  if type(filetypes)=='table' then
    for _,v in pairs(filetypes) do
      if v==val then
        return true
      end
    end
  elseif type(filetypes)=='string' then
    if filetypes==val then
      return true
    end
  end
  return false
end

local check_server_support_codeaction=function(bufnr)
  local clients=vim.lsp.get_active_clients({buffer=bufnr,})
  for _,client in pairs(clients) do
    if
      not client.config.filetypes
      and next(server_filetype_map)~=nil
    then
      for _,fts in pairs(server_filetype_map) do
        if has_value(fts,vim.bo[bufnr].filetype) then
          client.config.filetypes=fts
          break
        end
      end
    end

    if
      client.supports_method(code_action_method)
      and has_value(client.config.filetypes,vim.bo[bufnr].filetype)
    then
      return true
    end
  end
  return false
end

local _update_virtual_text=function(bufnr,line)
  local namespace=vim.api.nvim_create_namespace('sagalightbulb')
  vim.api.nvim_buf_clear_namespace(bufnr,namespace,0,-1)

  if line then
    local icon_with_indent='  '..code_action_icon
    pcall(vim.api.nvim_buf_set_extmark,bufnr,namespace,line,-1,{
      hl_mode='combine',
      virt_text={{icon_with_indent,'LspSagaLightBulb',},},
      virt_text_pos='overlay',
    })
  end
end

local generate_sign=function(bufnr,line)
  vim.fn.sign_place(
  line,SIGN_GROUP,SIGN_NAME,bufnr,{
    lnum=line+1,
    priority=code_action_lightbulb_config.sign_priority,
  })
end

local _update_sign=function(bufnr,line)
  if vim.w.lightbulb_line==0 then
    vim.w.lightbulb_line=1
  end
  if vim.w.lightbulb_line~=0 then
    vim.fn.sign_unplace(SIGN_GROUP,{
      bufnr=bufnr,
      id=vim.w.lightbulb_line,
    })
  end

  if line then
    generate_sign(bufnr,line)
    vim.w.lightbulb_line=line
  end
end

local render_action_virtual_text=function(bufnr,line,has_actions)
  if not vim.api.nvim_buf_is_valid(bufnr) then
    return
  end
  if not has_actions then
    if code_action_lightbulb_config.virtual_text then
      _update_sign(bufnr,nil)
    end
    if code_action_lightbulb_config.sign then
      _update_sign(bufnr,nil)
    end
    return
  end

  if code_action_lightbulb_config.sign then
    _update_sign(bufnr,line)
  end

  if code_action_lightbulb_config.virtual_text then
    _update_virtual_text(bufnr,line)
  end
end

local send_request=coroutine.create(function()
  local current_buf=vim.api.nvim_get_current_buf()
  vim.w.lightbulb_line=vim.w.lightbulb_line or 0

  while true do
    local diagnostics=vim.lsp.diagnostic.get_line_diagnostics(
    current_buf)
    local context={diagnostics=diagnostics,}
    local params=vim.lsp.util.make_range_params()
    params.context=context
    local line=params.range.start.line
    vim.lsp.buf_request_all(
    current_buf,
    code_action_method,
    params,
    function(results)
      local has_actions=false
      for _,res in pairs(results or {}) do
        if
          res.result
          and type(res.result)=='table'
          and next(res.result)~=nil
        then
          has_actions=true
          break
        end
      end
      render_action_virtual_text(current_buf,line,has_actions)
    end)
    current_buf=coroutine.yield()
  end
end)

local render_bulb=function(bufnr)
  local has_code_action=check_server_support_codeaction(bufnr)
  if not has_code_action then
    return
  end
  coroutine.resume(send_request,bufnr)
end

local check_lsp_action=function(silent)
  silent=silent or true
  local current_buf=vim.api.nvim_get_current_buf()
  local active_clients=vim.lsp.get_active_clients({buffer=current_buf,})
  if next(active_clients)==nil then
    if not silent then
      vim.notify('[LspSaga] Current buffer does not have any lsp server')
    end
    return false
  end
  return true
end

lb.action_lightbulb=function()
  if not check_lsp_action(false) then
    return
  end

  timer:stop()

  local current_buf=vim.api.nvim_get_current_buf()
  timer:start(
  code_action_lightbulb_config.update_time,
  0,
  function()
    vim.schedule(function()
      render_bulb(current_buf)
    end)
  end)
end

lb.lb_autocmd=function()
  local lightbulb_group=vim.api.nvim_create_augroup(
  'LspSagaLightBulb',{clear=true,})
  if vim.fn.has('nvim-0.8')==1 then
    vim.api.nvim_create_autocmd(
    'LspAttach',
    {
      callback=function()
        local current_buf=vim.api.nvim_get_current_buf()
        local group=vim.api.nvim_create_augroup(
        'LspSagaLightBulb'..tostring(current_buf),{})
        vim.api.nvim_create_autocmd(
        {'CursorMoved',},
        {buffer=current_buf,callback=lb.action_lightbulb,group=group,})

        if not code_action_lightbulb_config.enable_in_insert then
          vim.api.nvim_create_autocmd(
          'InsertEnter',
          {
            buffer=current_buf,
            callback=function()
              _update_sign(current_buf,nil)
              _update_virtual_text(current_buf,nil)
            end,
            group=group,
          })
        end

        buf_auid[current_buf]=group

        vim.api.nvim_create_autocmd(
        'BufDelete',
        {
          buffer=current_buf,
          callback=function(opt)
            if buf_auid[opt.buf] then
              pcall(vim.api.nvim_del_augroup_by_id,buf_auid[opt.buf])
              rawset(buf_auid,opt.buf,nil)
            end
          end,
        })
      end,
      group=lightbulb_group,
    })
    return
  end
end

return lb
