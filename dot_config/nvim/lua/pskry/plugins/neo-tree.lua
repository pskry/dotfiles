-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  cmd = 'Neotree',
  keys = {
    { '\\', ':Neotree reveal toggle=true<CR>', desc = 'NeoTree reveal', silent = true },
    { '<leader>b', ':Neotree toggle show buffers right<CR>', desc = 'NeoTree show buffers right', silent = false },
    { '<leader>gs', ':Neotree float git_status<CR>', desc = 'NeoTree git status', silent = false },
  },
  opts = {
    filesystem = {
      window = {
        mappings = {
          ['\\'] = 'close_window',
        },
      },
    },
  },
  config = function()
    require('neo-tree').setup {
      close_iflast_window = false,
    }
  end,
}
