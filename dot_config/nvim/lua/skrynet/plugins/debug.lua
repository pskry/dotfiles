-- INFO: Debug Adapter Protocol (DAP) client implementation for Neovim
-- DOCS: https://github.com/mfussenegger/nvim-dap
return {
  'mfussenegger/nvim-dap',
  dependencies = {
    -- Beautiful debugger UI
    'rcarriga/nvim-dap-ui',
    -- Required for nvim-dap-ui
    'nvim-neotest/nvim-nio',

    -- Automatic debug adapter install via mason
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    -- Debugger adapters
    'leoluz/nvim-dap-go',
  },
  keys = {
    -- Basics
    {
      '<F9>',
      function()
        require('dap').continue()
      end,
      desc = 'Debug: Start/Continue',
    },
    {
      '<F7>',
      function()
        require('dap').step_into()
      end,
      desc = 'Debug: Step Into',
    },
    {
      '<F8>',
      function()
        require('dap').step_over()
      end,
      desc = 'Debug: Step Over',
    },
    {
      '<F6>',
      function()
        require('dap').step_out()
      end,
      desc = 'Debug: Step Out',
    },
    { -- Toggle to see last session result.
      -- NOTE: Without this, we'll be unable to see session output in case of unhandled exceptions
      '<F10>',
      function()
        require('dapui').toggle()
      end,
      desc = 'Debug: See last session result.',
    },
    -- Breakpoints
    {
      '<leader>bb',
      function()
        require('dap').toggle_breakpoint()
      end,
      desc = 'Debug: Toggle Breakpoint',
    },
    {
      '<leader>bc',
      function()
        require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
      end,
      desc = 'Debug: Set Conditional Breakpoint',
    },
    {
      '<leader>bl',
      function()
        require('dap').set_breakpoint(nil, nil, vim.fn.input 'Log message: ')
      end,
      desc = 'Debug: Set Logpoint',
    },
    -- Debugger controls
    {
      '<leader>br',
      function()
        require('dap').restart()
      end,
      desc = 'Debug: Restart',
    },
    {
      '<leader>bp',
      function()
        require('dap').pause()
      end,
      desc = 'Debug: Pause Thread',
    },
    {
      '<leader>bs',
      function()
        require('dap').close()
      end,
      desc = 'Debug: Stop',
    },
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    -- INFO: mason-nvim-dap bridges `mason.nvim` with the nvim-dap plugin
    -- DOCS: https://github.com/jay-babu/mason-nvim-dap.nvim
    require('mason-nvim-dap').setup {
      -- Best effort auto-install debuggers listed in `ensure_installed`
      automatic_installation = true,
      handlers = {},
      ensure_installed = {
        'delve', -- go
      },
    }

    -- UI setup
    -- INFO: A UI for nvim-dap which provides a good out of the box configuration
    -- DOCS: https://github.com/rcarriga/nvim-dap-ui
    dapui.setup {
      icons = {
        expanded = '▾',
        collapsed = '▸',
        current_frame = '*',
      },
      controls = {
        icons = {
          pause = '',
          play = '',
          step_into = '',
          step_over = '',
          step_out = '',
          step_back = '',
          run_last = '',
          terminate = '',
          disconnect = '',
        },
      },
    }

    -- Change breakpoint icons
    vim.api.nvim_set_hl(0, 'DapBreak', { link = 'DiagnosticError' })
    vim.api.nvim_set_hl(0, 'DapStop', { link = 'DiagnosticWarn' })
    vim.fn.sign_define('DapBreakpoint', { text = '', texthl = 'DapBreak', numhl = 'DapBreak' })
    vim.fn.sign_define('DapBreakpointCondition', { text = '', texthl = 'DapBreak', numhl = 'DapBreak' })
    vim.fn.sign_define('DapBreakpointRejected', { text = '', texthl = 'DapBreak', numhl = 'DapBreak' })
    vim.fn.sign_define('DapLogPoint', { text = '', texthl = 'DapBreak', numhl = 'DapBreak' })
    vim.fn.sign_define('DapStopped', { text = '', texthl = 'DapStop', numhl = 'DapStop', linehl = 'debugPC' })

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    -- Go
    require('dap-go').setup {
      delve = {
        -- On Windows delve must be run attached or it crashes (lol)
        detached = vim.fn.has 'win32' == 0,
      },
    }
  end,
}
