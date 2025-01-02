-- au BufRead,BufNewFile */playbooks/*.yml setlocal ft=yaml.ansible
-- au BufRead,BufNewFile */playbooks/*.yaml setlocal ft=yaml.ansible
-- au BufRead,BufNewFile */roles/*/tasks/*.yml setlocal ft=yaml.ansible
-- au BufRead,BufNewFile */roles/*/tasks/*.yaml setlocal ft=yaml.ansible
-- au BufRead,BufNewFile */roles/*/handlers/*.yml setlocal ft=yaml.ansible
-- au BufRead,BufNewFile */roles/*/handlers/*.yaml setlocal ft=yaml.ansible
local function add(pattern)
  vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    pattern = pattern,
    callback = function()
      vim.bo.filetype = 'yaml.ansible'
    end,
  })
end

-- add '*/roles/*/tasks/*.yaml'
vim.api.nvim_create_autocmd({
  'BufRead',
  'BufNewFile',
}, {
  pattern = {
    -- "*/ansible/*.yml",
    -- "*/tasks/*.yml",
    '*/roles/*/tasks/*.yaml',
    '*/roles/*/handlers/*.yaml',
  },
  callback = function()
    vim.bo.filetype = 'yaml.ansible'
  end,
})
