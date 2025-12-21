vim.api.nvim_create_autocmd('FileType', {
  pattern = 'jinja',
  callback = function()
    local name = vim.api.nvim_buf_get_name(0)

    if name:match '%.ya?ml%.j2$' then
      vim.bo.filetype = 'yaml.jinja'
    elseif name:match '%.ini%.j2$' then
      vim.bo.filetype = 'dosini.jinja'
    elseif name:match '%.cfg%.j2$' then
      vim.bo.filetype = 'conf.jinja'
    end
  end,
})
