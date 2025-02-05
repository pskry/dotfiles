return {
  {
    'ellisonleao/gruvbox.nvim',
    opts = {
      contrast = '', -- 'hard', 'soft' or '' (medium)
      overrides = {
        SignColumn = { link = 'GruvboxBg0' },
        GruvboxRedSign = { link = 'GruvboxRed' },
        GruvboxAquaSign = { link = 'GruvboxAqua' },
        GruvboxBlueSign = { link = 'GruvboxBlue' },
        GruvboxGreenSign = { link = 'GruvboxGreen' },
        GruvboxOrangeSign = { link = 'GruvboxOrange' },
        GruvboxPurpleSign = { link = 'GruvboxPurple' },
        GruvboxYellowSign = { link = 'GruvboxYellow' },
      },
    },
  },
  {
    'LazyVim/LazyVim',
    opts = {
      colorscheme = 'gruvbox',
    },
  },

  {
    'nvim-lualine/lualine.nvim',
    opts = function(_, opts)
      opts.sections.lualine_z = opts.sections.lualine_y
      opts.sections.lualine_y = {
        'encoding',
        {
          'fileformat',
          padding = {
            left = 1,
            right = 2,
          },
        },
      }
      -- TODO: trouble statusline highlight
    end,
  },

  {
    'nvim-neo-tree/neo-tree.nvim',
    dependencies = {
      {
        's1n7ax/nvim-window-picker',
        version = '2.*',
        opts = {
          filter_rules = {
            include_current_win = false,
            autoselect_one = true,
            bo = {
              -- ignore filetypes
              filetype = { 'neo-tree', 'neo-tree-popup', 'notify' },
              -- ignore buftypes
              buftype = { 'terminal', 'quickfix' },
            },
          },
        },
      },
    },
    keys = {
      { '\\', ':Neotree reveal<CR>', desc = 'NeoTree Files', silent = true },
      { '|', ':Neotree reveal buffers<CR>', desc = 'NeoTree Buffers', silent = true },
      { '<C-\\>', ':Neotree reveal git_status<CR>', desc = 'NeoTree Git', silent = true },
    },
    opts = {
      git_status_async = false,
      popup_border_style = 'rounded',
      default_component_configs = {
        modified = {
          symbol = LazyVim.config.icons.git.modified,
        },
        git_status = {
          symbols = {
            -- Change type
            added = '',
            deleted = '',
            modified = '',
            renamed = '',
            -- Status type
            untracked = '',
            ignored = '',
            unstaged = '',
            staged = '',
            conflict = '󰋔',
          },
        },
      },
      -- FIXME: language
      nesting_rules = {
        ['go'] = {
          pattern = '(.*)%.go$',
          files = { '%1_test.go' },
        },
        ['go.mod'] = {
          pattern = 'go.mod',
          files = { 'go.sum' },
        },
      },
      window = {
        mappings = {
          ['<space>'] = 'none',
          ['<2-leftmouse>'] = 'none',
          ['h'] = 'close_node',
          ['l'] = 'toggle_node',
          ['Y'] = {
            function(state)
              local node = state.tree:get_node()
              local path = node:get_id()
              vim.fn.setreg('+', path, 'c')
            end,
            desc = 'copy_path',
          },
        },
      },
      filesystem = {
        group_empty_dirs = false,
        use_libuv_file_watcher = true,
        window = {
          mappings = {
            ['\\'] = 'close_window',
            ['ga'] = 'git_add_file',
            ['gc'] = 'git_commit',
            ['gg'] = 'git_commit_and_push',
            ['gp'] = 'git_push',
            ['gr'] = 'git_revert_file',
            ['gu'] = 'git_unstage_file',
          },
        },
        filtered_items = {
          visible = true,
          never_show = {
            '.DS_Store',
            'thumbs.db',
          },
        },
        follow_current_file = {
          enabled = true,
          leave_dirs_open = true,
        },
      },
      buffers = {
        window = {
          mappings = {
            ['|'] = 'close_window',
          },
        },
      },
      git_status = {
        window = {
          mappings = {
            ['<C-\\>'] = 'close_window',
          },
        },
      },
    },
  },

  {
    'kevinhwang91/nvim-ufo',
    dependencies = {
      'kevinhwang91/promise-async',
    },
    opts = {},
  },

  {
    'folke/snacks.nvim',
    ---@type snacks.Config
    opts = {
      scroll = { enabled = false },
    },
  },

  {
    'saghen/blink.cmp',
    opts = {
      keymap = {
        preset = 'super-tab',
      },
    },
  },

  {
    'folke/lazydev.nvim',
    opts = function(_, opts)
      local libs = {
        { path = 'snacks.nvim', words = { 'Snacks', 'snacks' } },
      }

      for _, lib in pairs(libs) do
        table.insert(opts.library, lib)
      end
    end,
  },

  {
    'brenton-leighton/multiple-cursors.nvim',
    version = '*', -- Use the latest tagged version
    enabled = false, -- TODO: Not really working as expected :(
    opts = function()
      local mc = require 'multiple-cursors'
      return {
        -- stylua: ignore
        custom_key_maps = {
          { 'n', '<Leader>|', function() mc.align() end },
        },
        pre_hook = function()
          vim.g.minipairs_disable = true
        end,
        post_hook = function()
          vim.g.minipairs_disable = false
        end,
      }
    end,
    keys = function()
      local mc = require 'multiple-cursors'
      return {
        {
          '<C-S-j>',
          function()
            mc.add_cursor_down()
          end,
          mode = { 'i', 'n', 'x', 'v' },
          desc = 'Add Cursor and move Down',
        },
        {
          '<C-S-k>',
          function()
            mc.add_cursor_up()
          end,
          mode = { 'i', 'n', 'x', 'v' },
          desc = 'Add Cursor and move Up',
        },
        {
          '<M-j>',
          function()
            vim.g.minipairs_disable = true
            mc.add_cursors_to_matches()
          end,
          mode = { 'i', 'n', 'x', 'v' },
          desc = 'Add Cursors to Matches',
        },
      }
    end,
    config = function(_, opts)
      require('multiple-cursors').setup(opts)
    end,
  },

  {
    'mfussenegger/nvim-dap',
    -- stylua: ignore
    keys = {
      { '<F7>', function() require('dap').step_into() end, desc = 'Step Into' },
      { '<F8>', function() require('dap').step_over() end, desc = 'Step Over' },
      { '<S-F8>', function() require('dap').step_out() end, desc = 'Step Out' },
      { '<F9>', function() require('dap').continue() end, desc = 'Run/Continue' },
      { '<F11>', function() require('dap').run_last() end, desc = 'Run Last' },
      { '<F12>', function() require('dap').continue() end, desc = 'Run/Continue' },
    },
  },
  {
    'fang2hou/go-impl.nvim',
    ft = 'go',
    dependencies = {
      'MunifTanjim/nui.nvim',
      'ibhagwan/fzf-lua',
      'nvim-lua/plenary.nvim',
    },
    opts = {},
    keys = {
      {
        '<leader>ci',
        function()
          require('go-impl').open()
        end,
        mode = { 'n' },
        desc = 'Go Impl',
      },
    },
  },

  {
    'ThePrimeagen/refactoring.nvim',
    keys = {
      { '<leader>rn', vim.lsp.buf.rename, desc = 'Rename' },
    },
  },

  {
    'mfussenegger/nvim-lint',
    dependencies = {
      { 'williamboman/mason.nvim', opts = {} },
      { 'rshkarin/mason-nvim-lint' },
    },
    opts = function(_, opts)
      opts.linters_by_ft = {
        go = { 'golangcilint' },
      }
      ---@diagnostic disable-next-line: missing-fields
      require('mason-nvim-lint').setup {}
    end,
  },

  {
    'alexghergh/nvim-tmux-navigation',
    -- stylua: ignore
    keys = {
      { '<C-h>', function() require('nvim-tmux-navigation').NvimTmuxNavigateLeft() end, desc = 'Go to Left Window' },
      { '<C-j>', function() require('nvim-tmux-navigation').NvimTmuxNavigateDown() end, desc = 'Go to Lower Window' },
      { '<C-k>', function() require('nvim-tmux-navigation').NvimTmuxNavigateUp() end, desc = 'Go to Upper Window' },
      { '<C-l>', function() require('nvim-tmux-navigation').NvimTmuxNavigateRight() end, desc = 'Go to Right Window' },
      { '<leader>wh', function() require('nvim-tmux-navigation').NvimTmuxNavigateLeft() end, desc = 'Go to Left Window' },
      { '<leader>wj', function() require('nvim-tmux-navigation').NvimTmuxNavigateDown() end, desc = 'Go to Lower Window' },
      { '<leader>wk', function() require('nvim-tmux-navigation').NvimTmuxNavigateUp() end, desc = 'Go to Upper Window' },
      { '<leader>wl', function() require('nvim-tmux-navigation').NvimTmuxNavigateRight() end, desc = 'Go to Right Window' },
    },
    config = function()
      local nav = require 'nvim-tmux-navigation'

      nav.setup {
        disable_when_zoomed = true, -- defaults to false
      }

      vim.keymap.set('n', '<C-h>', nav.NvimTmuxNavigateLeft)
      vim.keymap.set('n', '<C-j>', nav.NvimTmuxNavigateDown)
      vim.keymap.set('n', '<C-k>', nav.NvimTmuxNavigateUp)
      vim.keymap.set('n', '<C-l>', nav.NvimTmuxNavigateRight)
      vim.keymap.set('n', '<C-\\>', nav.NvimTmuxNavigateLastActive)
      vim.keymap.set('n', '<C-Space>', nav.NvimTmuxNavigateNext)
    end,
  },

  -- import extras
  { import = 'lazyvim.plugins.extras.lang.go' },
  { import = 'lazyvim.plugins.extras.lsp.none-ls' },
  { import = 'lazyvim.plugins.extras.coding.mini-surround' },
  { import = 'lazyvim.plugins.extras.dap.core' },
  { import = 'lazyvim.plugins.extras.util.chezmoi' },
  { import = 'lazyvim.plugins.extras.lang.json' },
  { import = 'lazyvim.plugins.extras.editor.refactoring' },
  { import = 'lazyvim.plugins.extras.editor.inc-rename' },
  { import = 'lazyvim.plugins.extras.editor.telescope' },

  -- disable
  { 'folke/flash.nvim', enabled = false },
}
