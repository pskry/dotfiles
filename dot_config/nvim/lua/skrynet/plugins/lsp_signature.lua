-- INFO: Show function signature when you type
-- DOCS: https://github.com/ray-x/lsp_signature.nvim
return {
  'ray-x/lsp_signature.nvim',
  event = 'VeryLazy',
  opts = {
    bind = true,
    hint_enable = true,
    hint_prefix = '🐼 ',
    padding = '',
    transparency = 10,
    handler_opts = {
      border = 'rounded',
    },
  },
  config = function(_, opts)
    require('lsp_signature').setup(opts)
  end,
}
