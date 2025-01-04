-- INFO: An asynchronous linter plugin for Neovim complementary to the built-in Language Server Protocol support.
-- DOCS: https://github.com/mfussenegger/nvim-lint
return {
  'mfussenegger/nvim-lint',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    local lint = require 'lint'
    lint.linters_by_ft = {
      markdown = { 'markdownlint' },
    }

    -- We allow for other plugins to add linters if necessary
    -- by not overwriting the whole `linters_by_ft` table.
    lint.linters_by_ft = lint.linters_by_ft or {}
    -- Disable default linters that are not installed
    lint.linters_by_ft['clojure'] = nil
    lint.linters_by_ft['dockerfile'] = nil
    lint.linters_by_ft['inko'] = nil
    lint.linters_by_ft['janet'] = nil
    lint.linters_by_ft['json'] = nil
    lint.linters_by_ft['markdown'] = nil
    lint.linters_by_ft['rst'] = nil
    lint.linters_by_ft['ruby'] = nil
    lint.linters_by_ft['terraform'] = nil
    lint.linters_by_ft['text'] = nil

    -- Enable linters
    lint.linters_by_ft['markdown'] = { 'markdownlint' }

    local lint_augroup = vim.api.nvim_create_augroup('skrynet-lint', { clear = true })
    vim.api.nvim_create_autocmd({
      'BufEnter',
      'BufWritePost',
      'InsertLeave',
    }, {
      group = lint_augroup,
      callback = function()
        -- Only run the linter in buffers that are modifiable in order to
        -- avoid superfluous noise, notably within the handy LSP pop-ups that
        -- describe the hovered symbol using Markdown.
        if vim.opt_local.modifiable:get() then
          lint.try_lint()
        end
      end,
    })
  end,
}
