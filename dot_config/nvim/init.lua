-- vim: fdm=marker ts=2 sts=2 sw=2 et

-- Plugin candidates ======================================================= {{{
--[[

https://github.com/jeffkreeftmeijer/vim-numbertoggle

--]]
-- Plugin candidates ======================================================= }}}

-- General Settings ======================================================== {{{

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Global neovim settings
-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

-- Backup & Undo
-- vim.opt.backup = false
-- vim.opt.writebackup = false
vim.opt.undofile = true

-- Editing
-- vim.opt.incsearch = true
-- vim.opt.infercase = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Indent
-- vim.opt.tabstop = 4
-- vim.opt.shiftwidth = 4
-- vim.opt.smartindent = true
vim.opt.breakindent = true

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Splits
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Display whitespace
vim.opt.list = true
vim.opt.showbreak = '↪ '
vim.opt.listchars = {
  eol = '¬',
  tab = '» ',
  space = '·',
  lead = '·',
  trail = '~',
  extends = '⟩',
  precedes = '⟨',
  nbsp = '␣',
}

-- Live substitutions
vim.opt.inccommand = 'split'

-- Appearance
vim.opt.termguicolors = true
vim.opt.cursorline = true
vim.opt.scrolloff = 10
vim.opt.signcolumn = 'yes'
-- vim.opt.linebreak = true
-- vim.opt.wrap = true
-- vim.opt.virtualedit = 'block'
vim.opt.showmode = false

-- Updates
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

vim.opt.mouse = 'a'

vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

-- General Settings ======================================================== }}}

-- Basic Keymaps =========================================================== {{{

-- Clear search highlights
vim.keymap.set({ 'n', 'i' }, '<Esc>', function()
  vim.cmd.nohlsearch()
  vim.cmd.stopinsert()
end, { desc = 'Clear everything' })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_next, { desc = 'Previous Diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Next Diagnostic message' })
vim.keymap.set('n', '<leader>de', vim.diagnostic.open_float, { desc = 'Show Error messages' })
vim.keymap.set('n', '<leader>dq', vim.diagnostic.setloclist, { desc = 'Open Quickfix list' })

-- Exit terminal mode in the builtin terminal with <Esc><Esc>
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
vim.keymap.set('t', '<Esc><Esc><Esc>', '<C-\\><C-n>:q<CR>', { desc = 'Close terminal window' })

-- Navigation
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Basic Keymaps =========================================================== }}}

-- Basic Autocommands ====================================================== {{{

local basic_augroup = vim.api.nvim_create_augroup('skrynet-basic', { clear = true })

-- Resume editing in last known cursor location
vim.api.nvim_create_autocmd({ 'BufReadPost' }, {
  pattern = { '*' },
  callback = function()
    vim.api.nvim_feedkeys('g`"', 'n', false)
    vim.schedule(function()
      vim.api.nvim_feedkeys('zxzz', 'n', false)
    end)
  end,
})

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking text',
  group = basic_augroup,
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Basic Autocommands ====================================================== }}}

-- Plugins ================================================================ {{{

-- lazy.nvim plugin-manager================================================ {{{
-- DOCS: :help lazy.nvim.txt
--       https://github.com/folke/lazy.nvim
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  vim.api.nvim_echo({ { 'cloing lazy.nvim...', 'InfoMsg' } }, true, {})
  local out = vim.fn.system({ 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
      { out, 'WarningMsg' },
    }, true, {})
  end
end
vim.opt.rtp:prepend(lazypath)

-- lazy.nvim plugin-manager================================================ }}}

require('lazy').setup({
  -- Editor Plugins ========================================================
  { -- ellisonleao/gruvbox.nvim {{{
    'ellisonleao/gruvbox.nvim',
    priority = 1000,
    opts = {},
    init = function()
      vim.cmd.colorscheme('gruvbox')
    end,
  }, -- ellisonleao/gruvbox.nvim }}}
  { -- tpope/vim-sleuth {{{
    'tpope/vim-sleuth',
  }, -- tpope/vim-sleuth }}}
  { -- folke/which-key.nvim {{{
    'folke/which-key.nvim',
    event = 'VimEnter',
    opts = {
      preset = 'classic',
      delay = 200,
      icons = {
        mappings = true,
        keys = {},
      },
      spec = {
        { '<leader>c', group = '[C]ode', mode = { 'n', 'x' } },
        { '<leader>d', group = '[D]ocument' },
        { '<leader>r', group = '[R]ename' },
        { '<leader>s', group = '[S]earch' },
        { '<leader>w', group = '[W]orkspace' },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
      },
    },
    keys = {},
    config = function(_, opts)
      require('which-key').setup(opts)
    end,
  }, -- folke/which-key.nvim }}}
  { -- lewis6991/gitsigns.nvim {{{
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        local gitsigns = require('gitsigns')

        local map = function(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']c', function()
          if vim.wo.diff then
            vim.cmd.normal({ ']c', bang = true })
          else
            gitsigns.nav_hunk('next')
          end
        end, { desc = 'Jump to next git [c]hange' })

        map('n', '[c', function()
          if vim.wo.diff then
            vim.cmd.normal({ '[c', bang = true })
          else
            gitsigns.nav_hunk('prev')
          end
        end, { desc = 'Jump to previous git [c]hange' })

        -- Actions
        -- visual mode
        map('v', '<leader>hs', function()
          gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
        end, { desc = 'git [s]tage hunk' })
        map('v', '<leader>hr', function()
          gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
        end, { desc = 'git [r]eset hunk' })
        -- normal mode
        map('n', '<leader>hs', gitsigns.stage_hunk, { desc = 'git [s]tage hunk' })
        map('n', '<leader>hr', gitsigns.reset_hunk, { desc = 'git [r]eset hunk' })
        map('n', '<leader>hS', gitsigns.stage_buffer, { desc = 'git [S]tage buffer' })
        map('n', '<leader>hu', gitsigns.undo_stage_hunk, { desc = 'git [u]ndo stage hunk' })
        map('n', '<leader>hR', gitsigns.reset_buffer, { desc = 'git [R]eset buffer' })
        map('n', '<leader>hp', gitsigns.preview_hunk, { desc = 'git [p]review hunk' })
        map('n', '<leader>hb', gitsigns.blame_line, { desc = 'git [b]lame line' })
        map('n', '<leader>hd', gitsigns.diffthis, { desc = 'git [d]iff against index' })
        map('n', '<leader>hD', function()
          gitsigns.diffthis('@')
        end, { desc = 'git [D]iff against last commit' })
        -- Toggles
        map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = '[T]oggle git show [b]lame line' })
        map('n', '<leader>tD', gitsigns.toggle_deleted, { desc = '[T]oggle git show [D]eleted' })
      end,
    },
  }, -- lewis6991/gitsigns.nvim }}}
  { -- echasnovski/mini.nvim {{{
    'echasnovski/mini.nvim',
    version = '*',
    config = function()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup({ n_lines = 500 })

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require('mini.surround').setup()

      -- Simple and easy statusline.
      local statusline = require('mini.statusline')
      statusline.setup()
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%3l:%-3v'
      end
    end,
  }, -- echasnovski/mini.nvim }}}
  { -- nvim-telescope/telescope.nvim {{{
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = '0.1.x',
    dependencies = {
      { -- Required shared library of common functions
        'nvim-lua/plenary.nvim',
      },
      { -- C port of fzf to use with telescope
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable('make') == 1
        end,
      },
      { -- Use telescope for all user selections
        'nvim-telescope/telescope-ui-select.nvim',
      },
      { -- Use pretty NerdFont glyphs
        'nvim-tree/nvim-web-devicons',
      },
    },
    config = function()
      require('telescope').setup({
        defaults = {
          mappings = {
            i = { ['<C-H>'] = 'select_horizontal' },
            n = { ['<C-H>'] = 'select_horizontal' },
          },
        },
        pickers = {},
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      })

      -- Enable Telescope extensions if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      -- See `:help telescope.builtin`
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sm', builtin.man_pages, { desc = '[S]earch [M]an Pages' })
      vim.keymap.set('n', '<leader>sR', builtin.registers, { desc = '[S]earch [R]egisters' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

      -- Fuzzily search in current buffer
      vim.keymap.set('n', '<leader>/', function()
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown({
          winblend = 10,
          previewer = false,
        }))
      end, { desc = '[/] Fuzzily search in current buffer' })

      -- Live Grep in Open Files
      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep({
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        })
      end, { desc = '[S]earch [/] in Open Files' })

      -- Shortcut for searching your Neovim configuration files
      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files({
          cwd = vim.fn.stdpath('config'),
        })
      end, { desc = '[S]earch [N]eovim files' })
    end,
  }, -- nvim-telescope/telescope.nvim }}}
  { -- lukas-reineke/indent-blankline.nvim {{{
    -- TODO: Configure rainbow guides?
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    ---@module 'ibl'
    ---@type ibl.config
    opts = {},
  }, -- lukas-reineke/indent-blankline.nvim }}}
  { -- nvim-neo-tree/neo-tree.nvim {{{
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
      'MunifTanjim/nui.nvim',
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
    cmd = 'Neotree',
    keys = {
      { '\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
    },
    opts = {
      sources = {
        'filesystem',
        'buffers',
        'git_status',
        'document_symbols',
      },
      git_status_async = false,
      popup_border_style = 'rounded',
      source_selector = {
        winbar = true,
        sources = {
          { source = 'filesystem' },
          { source = 'buffers' },
          { source = 'git_status' },
          { source = 'document_symbols' },
        },
      },

      default_component_configs = {
        modified = {
          symbol = '[+]',
        },
        name = {
          highlight_opened_files = true,
        },
      },
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
      filesystem = {
        window = {
          mappings = {
            ['\\'] = 'close_window',
          },
        },
        filtered_items = {
          visible = true,
          never_show = {
            '.DS_Store',
            'thumbs.db',
          },
        },
        group_empty_dirs = true,
        follow_current_file = {
          enabled = true,
          leave_dirs_open = true,
        },
        use_libuv_file_watcher = true,
      },
    },
  }, -- nvim-neo-tree/neo-tree.nvim }}}
  -- Coding Plugins ========================================================
  { -- mfussenegger/nvim-lint {{{
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
      linters_by_ft = {
        markdown = { 'markdownlint' },
      },
    },
    config = function(_, opts)
      local lint = require('lint')
      lint.linters_by_ft = lint.linters_by_ft or {}

      -- Disable default linters
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

      -- Enable linters explicitly
      for key, value in pairs(opts.linters_by_ft or {}) do
        lint.linters_by_ft[key] = value
      end

      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = vim.api.nvim_create_augroup('lint', { clear = true }),
        callback = function()
          -- Only run the linter in buffers that you can modify in order to
          -- avoid superfluous noise, notably within the handy LSP pop-ups that
          -- describe the hovered symbol using Markdown.
          if vim.opt_local.modifiable:get() then
            lint.try_lint()
          end
        end,
      })
    end,
  }, -- mfussenegger/nvim-lint }}}
  { -- Bilal2453/luvit-meta {{{
    'Bilal2453/luvit-meta',
    lazy = true,
  }, -- Bilal2453/luvit-meta }}}
  { -- lazydev.nvim {{{
    'folke/lazydev.nvim',
    ft = 'lua',
    cmd = 'LazyDev',
    opts = {
      library = {
        { path = 'luvit-meta/library', words = { 'vim%.uv' } },
      },
    },
  }, -- folke/lazydev.nvim }}}
  { -- stevearc/conform.nvim {{{
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format({ async = true, lsp_format = 'fallback' })
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true, cpp = true }
        local lsp_format_opt
        if disable_filetypes[vim.bo[bufnr].filetype] then
          lsp_format_opt = 'never'
        else
          lsp_format_opt = 'fallback'
        end
        return {
          timeout_ms = 500,
          lsp_format = lsp_format_opt,
        }
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
      },
    },
  }, -- stevearc/conform.nvim }}}
  { -- folke/todo-comments.nvim {{{
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false },
  }, -- folke/todo-comments.nvim }}}
  { -- hrsh7th/nvim-cmp {{{
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      {
        -- Snippet Engine & its associated nvim-cmp source
        'L3MON4D3/LuaSnip',
        build = 'make install_jsregexp',
        cond = function()
          return vim.fn.executable('make') == 1
        end,
        dependencies = {
          {
            'rafamadriz/friendly-snippets',
            config = function()
              require('luasnip.loaders.from_vscode').lazy_load()
            end,
          },
        },
      },
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
    },
    config = function()
      -- See `:help cmp`
      local cmp = require('cmp')
      local luasnip = require('luasnip')
      luasnip.config.setup({})

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = { completeopt = 'menu,menuone,noinsert' },
        mapping = cmp.mapping.preset.insert({
          -- Select items
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<C-p>'] = cmp.mapping.select_prev_item(),

          -- Scroll the documentation
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),

          -- Accept the completion.
          ['<Tab>'] = cmp.mapping.confirm({ select = true }),

          -- Manually trigger a completion from nvim-cmp.
          ['<C-Space>'] = cmp.mapping.complete({}),

          -- Move through snippet expansion locations
          ['<C-l>'] = cmp.mapping(function()
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { 'i', 's' }),
          ['<C-h>'] = cmp.mapping(function()
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { 'i', 's' }),
        }),
        sources = {
          {
            name = 'lazydev',
            -- set group index to 0 to skip loading LuaLS completions as lazydev recommends it
            group_index = 0,
          },
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'path' },
        },
      })
    end,
  }, -- hrsh7th/nvim-cmp }}}
  { -- windwp/nvim-autopairs {{{
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    dependencies = {
      'hrsh7th/nvim-cmp',
    },
    config = function()
      require('nvim-autopairs').setup({})
      -- Automatically add `(` after selecting a function or method
      local cmp_autopairs = require('nvim-autopairs.completion.cmp')
      local cmp = require('cmp')
      cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
    end,
  }, -- windwp/nvim-autopairs }}}
  -- LSP Plugins ===========================================================
  { -- neovim/nvim-lspconfig {{{
    'neovim/nvim-lspconfig',
    dependencies = {
      { -- NOTE: MUST be loaded before dependants
        'williamboman/mason.nvim',
        opts = {},
      },
      { -- bridges mason.nvim with the lspconfig plugin
        'williamboman/mason-lspconfig.nvim',
      },
      { -- Installs and upgrades third-party tools
        'WhoIsSethDaniel/mason-tool-installer.nvim',
      },
      { -- Extensible UI for Neovim notifications and LSP progress messages
        'j-hui/fidget.nvim',
        opts = {},
      },
      { -- Allows extra capabilities provided by nvim-cmp
        'hrsh7th/cmp-nvim-lsp',
      },
    },
    opts = {
      ---@type table<string, lspconfig.Config>
      servers = {
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = {
                disable = {
                  'missing-fields',
                },
              },
              workspace = {
                checkThirdParty = false,
              },
              codeLens = {
                enable = true,
              },
              completion = {
                callSnippet = 'Replace',
              },
              doc = {
                privateName = { '^_' },
              },
              hint = {
                enable = true,
                -- setType = false,
                -- paramType = true,
                -- paramName = "Disable",
                -- semicolon = "Disable",
                -- arrayIndex = "Disable",
              },
            },
          },
        },
      },
      tools = {
        'stylua',
      },
      ---@type vim.diagnostic.Opts
      diagnostics = {
        severity_sort = true,
        underline = true,
        update_in_insert = false,
        signs = {
          text = { '', '', '', '' },
        },
        virtual_text = {
          spacing = 2,
          source = 'if_many',
          prefix = function(diagnostic)
            local icons = { '', '', '', '' }
            return icons[diagnostic.severity]
          end,
        },
      },
      -- inlay_hints = {
      --   enabled = true,
      --   exclude = {},
      -- },
      -- codelens = {
      --   enabled = true,
      -- },
      -- capabilities = {
      --   workspace = {
      --     fileOperations = {
      --       didRename = true,
      --       willRename = true,
      --     },
      --   },
      -- },
    },
    config = function(_, opts)
      vim.api.nvim_create_autocmd('LspAttach', { -- on_attach {{{
        group = vim.api.nvim_create_augroup('skrynet-lsp-attach', { clear = true }),
        callback = function(attach_event)
          ---@param lhs   string           Left-hand side |{lhs}| of the mapping.
          ---@param rhs   string|function  Right-hand side |{rhs}| of the mapping, can be a Lua function.
          ---@param desc  string           Description
          ---@param mode? string|string[]  Mode short-name, see |nvim_set_keymap()|.
          ---                              Can also be list of modes to create mapping on multiple modes.
          local map = function(lhs, rhs, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, lhs, rhs, { buffer = attach_event.buf, desc = 'LSP: ' .. desc })
          end

          local builtin = require('telescope.builtin')
          -- Goto stuff
          map('gd', builtin.lsp_definitions, '[G]oto [D]efinition')
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
          map('gr', builtin.lsp_references, '[G]oto [R]eferences')
          map('gI', builtin.lsp_implementations, '[G]oto [I]mplementation')
          map('<leader>D', builtin.lsp_type_definitions, 'Type [D]efinition')
          map('<leader>ds', builtin.lsp_document_symbols, '[D]ocument [S]ymbols')

          -- Code actions

          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })

          -- Workspace
          map('<leader>ws', builtin.lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

          -- Refactoring
          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

          -- LSP hover text
          map('K', vim.lsp.buf.hover, 'Hover')
          map('<leader>k', vim.lsp.buf.hover, 'Hover')

          local client = vim.lsp.get_client_by_id(attach_event.data.client_id)
          if not client then
            return
          end

          local methods = vim.lsp.protocol.Methods

          -- inlay hints
          if client.supports_method(methods.textDocument_inlayHint) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = attach_event.buf }))
            end, '[T]oggle Inlay [H]ints')
          end

          -- document highlight
          if client.supports_method(methods.textDocument_documentHighlight) then
            local highlight_group = vim.api.nvim_create_augroup('skrynet-lsp-highlight', { clear = false })
            -- highlight under cursor on hold
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = attach_event.buf,
              group = highlight_group,
              callback = vim.lsp.buf.document_highlight,
            })
            -- remove highlight under cursor on move
            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = attach_event.buf,
              group = highlight_group,
              callback = vim.lsp.buf.clear_references,
            })
            -- remove document highlighting on LSP detach
            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('skrynet-lsp-detach', { clear = true }),
              callback = function(detach_event)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds({ group = 'skrynet-lsp-highlight', buffer = detach_event.buf })
              end,
            })
          end
        end,
      }) -- on_attach }}}

      -- diagnostics
      vim.diagnostic.config(vim.deepcopy(opts.diagnostics or {}))

      -- ensure language-servers and tools are installed
      local servers = opts.servers or {}
      local ensure_installed = vim.list_extend(vim.tbl_keys(servers or {}), opts.tools or {})

      -- trigger FileType event on successful package install
      -- to enable loading the newly installed package
      require('mason-registry'):on('package:install:success', function()
        vim.defer_fn(function()
          require('lazy.core.handler.event').trigger({
            event = 'FileType',
            buf = vim.api.nvim_get_current_buf(),
          })
        end, 100)
      end)

      require('mason-tool-installer').setup({ ensure_installed = ensure_installed })

      -- configure language-servers
      local capabilities = vim.tbl_deep_extend(
        'force',
        {},
        vim.lsp.protocol.make_client_capabilities(),
        require('cmp_nvim_lsp').default_capabilities(),
        opts.capabilities or {}
      )

      require('mason-lspconfig').setup({
        ensure_installed = {},
        automatic_installation = true,
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            if server.enabled == false then
              return
            end

            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      })
    end,
  }, -- neovim/nvim-lspconfig }}}
  { -- nvim-treesitter/nvim-treesitter {{{
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-context',
    },
    opts = {
      ensure_installed = {
        'bash',
        'c',
        'diff',
        'html',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'query',
        'vim',
        'vimdoc',
      },
      auto_install = true,
      highlight = {
        enable = true,
        -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = {
        enable = true,
        disable = { 'ruby' },
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = 'gnn',
          node_incremental = 'grn',
          scope_incremental = 'grc',
          node_decremental = 'grm',
        },
      },
      -- TODO: textobjects
      --       https://github.com/nvim-treesitter/nvim-treesitter-textobjects
    },
    config = function(_, opts)
      require('nvim-treesitter.configs').setup(opts)

      -- context
      require('treesitter-context').setup({
        enable = true,
        multiwindow = false,
        max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
        min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
        line_numbers = true,
        multiline_threshold = 20, -- Maximum number of lines to show for a single context
        trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
        mode = 'cursor', -- Line used to calculate context. Choices: 'cursor', 'topline'
        separator = nil, -- Separator between context and content. Should be a single character string, like '-'.
        zindex = 20, -- The Z-index of the context window
        on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
      })
    end,
  }, -- nvim-treesitter/nvim-treesitter }}}
}, {
  rocks = {
    enabled = false,
  },
  ui = {
    border = 'rounded',
    change_detection = {
      enabled = true,
      notify = true, -- get a notification when changes are found
    },
  },
})

-- Plugins ================================================================ }}}
