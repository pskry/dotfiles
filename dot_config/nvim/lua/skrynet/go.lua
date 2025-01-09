-- INFO: A modern go neovim plugin based on treesitter, nvim-lsp and dap debugger.
-- DOCS: https://github.com/ray-x/go.nvim
return {
  'ray-x/go.nvim',
  dependencies = {
    -- 'ray-x/guihua.lua',
    'neovim/nvim-lspconfig',
    'nvim-treesitter/nvim-treesitter',
  },
  config = function()
    require('go').setup()
  end,
  event = { 'CmdlineEnter' },
  ft = { 'go', 'gomod' },
  build = ':lua require("go.install").update_all_sync()',
}
