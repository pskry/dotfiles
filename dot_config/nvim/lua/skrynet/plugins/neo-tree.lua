-- INFO: Browse the file system and other tree like structures in style.
--       Includes sidebars, floating windows, netrw split style
-- DOCS: https://github.com/nvim-neo-tree/neo-tree.nvim
return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'MunifTanjim/nui.nvim',
  },
  cmd = 'Neotree',
  keys = {
    { '\\', ':Neotree reveal toggle=true<CR>', desc = 'NeoTree toggle', silent = true },
    { '<leader>nb', ':Neotree toggle show buffers right<CR>', desc = 'NeoTree show buffers right', silent = false },
    { '<leader>ng', ':Neotree float git_status<CR>', desc = 'NeoTree git status', silent = false },
  },
  opts = {
    close_iflast_window = false,
    filesystem = {
      window = {
        mappings = {
          ['\\'] = 'close_window',
        },
      },
    },
  },
  config = function()
    require('neo-tree').setup()
  end,
}
