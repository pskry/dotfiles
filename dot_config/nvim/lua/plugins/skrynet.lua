function _G.get_oil_winbar()
  local bufnr = vim.api.nvim_win_get_buf(vim.g.statusline_winid)
  local dir = require('oil').get_current_dir(bufnr)
  if dir then
    return ' 󰏇  ' .. vim.fn.fnamemodify(dir, ':~')
  else
    -- If there is no current directory (e.g. over ssh), just show the buffer name
    return ' 󰏇  ' .. vim.api.nvim_buf_get_name(0)
  end
end

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
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, _)
      vim.filetype.add {
        extension = {
          yamllint = 'yaml',
          ['ansible-lint'] = 'yaml',
          tfstate = 'json',
          ['tfstate.backup'] = 'json',
        },
        pattern = {},
      }
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
    version = '*', -- Use the latest tagged version
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
      { 'mason-org/mason.nvim', opts = {} },
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

  {
    'nvim-telescope/telescope.nvim',
    keys = {
      {
        '<leader>fh',
        function()
          require('telescope.builtin').find_files { no_ignore = true }
        end,
        desc = 'Find Hidden (Root Dir)',
      },
    },
  },

  {
    'stevearc/oil.nvim',
    dependencies = {
      { 'nvim-mini/mini.icons', opts = {} },
    },
    lazy = false,
    ---@module 'oil'
    ---@type oil.SetupOpts
    keys = {
      { '<M-o>', ':Oil<CR>', desc = 'Oil', silent = true },
    },
    opts = {
      default_file_explorer = true,
      columns = {
        'icon',
        -- 'permissions',
        -- 'size',
        -- 'mtime',
      },
      buf_options = {
        buflisted = false,
        bufhidden = 'hide',
      },
      keymaps = {
        ['<M-o>'] = { 'actions.close', mode = 'n' },
      },
      win_options = {
        winbar = '%!v:lua.get_oil_winbar()',
        signcolumn = 'yes:2',
      },
      view_options = {
        is_hidden_file = function(name, bufnr)
          local function parse_output(proc)
            local result = proc:wait()
            local ret = {}
            if result.code == 0 then
              for line in vim.gsplit(result.stdout, '\n', { plain = true, trimempty = true }) do
                -- Remove trailing slash
                line = line:gsub('/$', '')
                ret[line] = true
              end
            end
            return ret
          end

          local function new_git_status()
            return setmetatable({}, {
              __index = function(self, key)
                local ignore_proc = vim.system(
                  { 'git', 'ls-files', '--ignored', '--exclude-standard', '--others', '--directory' },
                  {
                    cwd = key,
                    text = true,
                  }
                )
                local tracked_proc = vim.system({ 'git', 'ls-tree', 'HEAD', '--name-only' }, {
                  cwd = key,
                  text = true,
                })
                local ret = {
                  ignored = parse_output(ignore_proc),
                  tracked = parse_output(tracked_proc),
                }

                rawset(self, key, ret)
                return ret
              end,
            })
          end

          local git_status = new_git_status()

          local refresh = require('oil.actions').refresh
          local orig_refresh = refresh.callback
          refresh.callback = function(...)
            git_status = new_git_status()
            orig_refresh(...)
          end

          local dir = require('oil').get_current_dir(bufnr)
          local is_dotfile = vim.startswith(name, '.') and name ~= '..'
          -- if no local directory (e.g. for ssh connections), just hide dotfiles
          if not dir then
            return is_dotfile
          end
          -- dotfiles are considered hidden unless tracked
          if is_dotfile then
            return not git_status[dir].tracked[name]
          else
            -- Check if file is gitignored
            return git_status[dir].ignored[name]
          end
        end,
      },
    },
  },
  {
    'refractalize/oil-git-status.nvim',
    dependencies = { 'stevearc/oil.nvim' },
    opts = {
      -- git_status = {
      --   symbols = {
      --     -- Change type
      --     added = '',
      --     deleted = '',
      --     modified = '',
      --     renamed = '',
      --     -- Status type
      --     untracked = '',
      --     ignored = '',
      --     unstaged = '',
      --     staged = '',
      --     conflict = '󰋔',
      --   },
      -- },
      symbols = {
        index = {
          ['!'] = '',
          ['?'] = '',
          ['A'] = '',
          ['C'] = 'C',
          ['D'] = '',
          ['M'] = '',
          ['R'] = '',
          ['T'] = 'T',
          ['U'] = 'U',
          [' '] = ' ',
        },
        working_tree = {
          ['!'] = '',
          ['?'] = '',
          ['A'] = '',
          ['C'] = 'C',
          ['D'] = '',
          ['M'] = '',
          ['R'] = '',
          ['T'] = 'T',
          ['U'] = 'U',
          [' '] = ' ',
        },
      },
    },
    config = function(_, opts)
      require('oil-git-status').setup(opts)

      vim.api.nvim_set_hl(0, 'OilGitStatusIndexIgnored', { link = 'OilHidden' })
      vim.api.nvim_set_hl(0, 'OilGitStatusWorkingTreeIgnored', { link = 'OilHidden' })
      -- overrides = {
      --   SignColumn = { link = 'GruvboxBg0' },
      --   GruvboxRedSign = { link = 'GruvboxRed' },
      --   GruvboxAquaSign = { link = 'GruvboxAqua' },
      --   GruvboxBlueSign = { link = 'GruvboxBlue' },
      --   GruvboxGreenSign = { link = 'GruvboxGreen' },
      --   GruvboxOrangeSign = { link = 'GruvboxOrange' },
      --   GruvboxPurpleSign = { link = 'GruvboxPurple' },
      --   GruvboxYellowSign = { link = 'GruvboxYellow' },
      -- },
    end,
  },

  {
    'apayu/nvim-ansible-vault',
    config = function()
      require('ansible-vault').setup {
        -- Optional custom configuration
        vault_password_files = { '.vault_pass', '.vault-pass' },
        patterns = {
          '*/host_vars/*/*_vault.yml',
          '*/host_vars/*/*_vault.yaml',
          '*/group_vars/*/*_vault.yml',
          '*/group_vars/*/*_vault.yaml',
          '*/HpSetup*.txt',
          '*/*_vault.tfstate',
        },
        vault_id = 'default',
      }
    end,
    event = {
      -- Load only when opening vault files
      'BufReadPre */*_vault.yml',
      'BufReadPre */*_vault.yaml',
      'BufReadPre */*_vault.tfstate',
    },
  },

  -- disable
  { 'folke/flash.nvim', enabled = false },
}
