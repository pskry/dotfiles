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

-- Polyfill :LspRestart. lspconfig used to ship it; the newer
-- vim.lsp.config flow dropped it. Stops every client and re-edits
-- every loaded unmodified buffer so the FileType/BufRead autocmds
-- reattach the LSP fresh, including a full workspace reindex.
vim.api.nvim_create_user_command('LspRestart', function()
  for _, c in ipairs(vim.lsp.get_clients()) do
    vim.lsp.stop_client(c.id, true)
  end
  vim.defer_fn(function()
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
      if
        vim.api.nvim_buf_is_loaded(bufnr)
        and not vim.bo[bufnr].modified
        and vim.bo[bufnr].buftype == '' -- skip terminal/help/nofile/prompt
        and vim.api.nvim_buf_get_name(bufnr) ~= '' -- skip scratch
      then
        vim.api.nvim_buf_call(bufnr, function()
          vim.cmd 'edit'
        end)
      end
    end
  end, 200)
end, { desc = 'Stop all LSP clients and reattach across loaded buffers' })
