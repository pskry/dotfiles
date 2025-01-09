return {
  'ThePrimeagen/refactoring.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
  },
  lazy = false,
  config = function()
    vim.keymap.set('x', '<leader>rf', ':Refactor extract ', { desc = 'Extract Function' })
    vim.keymap.set('x', '<leader>rF', ':Refactor extract_to_file ', { desc = 'Extract to File' })
    vim.keymap.set('x', '<leader>rv', ':Refactor extract_var ', { desc = 'Extract Variable' })
    vim.keymap.set('n', '<leader>rb', ':Refactor extract_block', { desc = 'Extract Block' })
    vim.keymap.set('n', '<leader>rB', ':Refactor extract_block_to_file', { desc = 'Extract Block to File' })
    vim.keymap.set('n', '<leader>ri', ':Refactor inline_var ', { desc = 'Inline Variable' })
    vim.keymap.set('n', '<leader>rI', ':Refactor inline_func ', { desc = 'Inline Function' })

    -- Select refactor
    vim.keymap.set({ 'n', 'x' }, '<leader>rr', require('refactoring').select_refactor, { desc = 'Select Refactor' })

    -- Insert print statements
    vim.keymap.set('n', '<leader>rpp', function()
      require('refactoring').debug.printf { below = false }
    end, { desc = 'Print Statement Above Cursor' })
    vim.keymap.set('n', '<leader>rpP', function()
      require('refactoring').debug.printf { below = true }
    end, { desc = 'Print Statement Below Cursor' })

    -- Print var
    vim.keymap.set({ 'x', 'n' }, '<leader>rpv', function()
      require('refactoring').debug.print_var {}
    end, { desc = 'Print Variable' })

    vim.keymap.set('n', '<leader>rpc', function()
      require('refactoring').debug.cleanup {}
    end, { desc = 'Cleanup Print Statements' })

    require('refactoring').setup {}
  end,
}
