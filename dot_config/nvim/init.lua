-- Set <space> as the leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- [[ Settings ]]
-- General
vim.opt.backup = false -- Don't store backup while overwriting the file
vim.opt.writebackup = false -- Don't store backup while overwriting the file

vim.cmd 'filetype plugin indent on' -- Enable all filetype plugins

-- Appearance
vim.opt.linebreak = true -- Wrap long lines at 'breakat' (if 'wrap' is set)
-- vim.opt.fillchars = 'eob: ' -- Don't show `~` outside of buffer

-- Editing
vim.opt.incsearch = true -- Show search results while typing
vim.opt.infercase = true -- Infer letter cases for a richer built-in keyword completion

vim.opt.virtualedit = 'block' -- Allow going past the end of line in visual block mode
-- vim.opt.formatoptions = 'qjl1' -- Don't autoformat comments

-- Indent width
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smartindent = true

-- Setup line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 250

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Set how neovim will display certain whitespace characters in the editor.
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 12

-- [[ Basic Keymaps ]]
-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_next, { desc = 'Goto previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Goto next [D]iagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with <Esc><Esc>
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Disable arrow keys in normal mode
vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Use CTRL+<hjkl> to switch between windows
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

vim.keymap.set('n', '[c', ':cprev<CR>', { desc = 'Goto previous Quickfix entry' })
vim.keymap.set('n', ']c', ':cnext<CR>', { desc = 'Goto next Quickfix entry' })

-- [[ Basic Autocommands ]]
--  Docs `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('skrynet-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- [[ Install `lazy.nvim` plugin manager ]]
--    Docs `:help lazy.nvim.txt`
--         https://github.com/folke/lazy.nvim
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end
vim.opt.rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
require('lazy').setup(
  { -- lazy.setup spec
    { -- Detect tabstop and shiftwidth automatically
      'tpope/vim-sleuth',
    }, -- tpope/vim-sleuth

    { -- Useful plugin to show you pending keybinds.
      'folke/which-key.nvim',
      event = 'VimEnter',
      opts = {
        icons = {
          -- since we're using a NerdFont, we use the graphical mappings
          mappings = true,
          keys = {},
        },

        -- Document existing key groups
        spec = {
          { '<leader>b', group = 'De[b]ug' },
          { '<leader>n', group = '[N]eoTree' },
          { '<leader>c', group = '[C]ode', mode = { 'n', 'x' } },
          { '<leader>d', group = '[D]ocument' },
          { '<leader>r', group = '[R]ename' },
          { '<leader>s', group = '[S]earch' },
          { '<leader>w', group = '[W]orkspace' },
          { '<leader>t', group = '[T]oggle' },
          { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
        },
      },
    }, -- folke/which-key.nvim

    { -- Fuzzy Finder
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
          -- only install and load this plugin when `make` is available
          cond = function()
            return vim.fn.executable 'make' == 1
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
        require('telescope').setup {
          -- You can put your default mappings / updates / etc. in here
          --  All the info you're looking for is in `:help telescope.setup()`
          --
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
        }

        -- Enable Telescope extensions
        pcall(require('telescope').load_extension, 'fzf')
        pcall(require('telescope').load_extension, 'ui-select')

        -- See `:help telescope.builtin`
        local builtin = require 'telescope.builtin'
        vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
        vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
        vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
        vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
        vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
        vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
        vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
        vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
        vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files' })
        vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = 'Find existing buffers' })

        -- Fuzzily search in current buffer
        vim.keymap.set('n', '<leader>/', function()
          builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
            winblend = 10,
            previewer = false,
          })
        end, { desc = 'Fuzzily search in current buffer' })

        -- Live Grep in Open Files
        vim.keymap.set('n', '<leader>s/', function()
          builtin.live_grep {
            grep_open_files = true,
            prompt_title = 'Live Grep in Open Files',
          }
        end, { desc = '[S]earch in Open Files' })

        -- Shortcut for searching your Neovim configuration files
        vim.keymap.set('n', '<leader>sn', function()
          builtin.find_files {
            cwd = vim.fn.stdpath 'config',
          }
        end, { desc = '[S]earch [N]eovim files' })
      end,
    }, -- nvim-telescope/telescope.nvim

    -- LSP Plugins
    { -- lazydev.nvim properly configures LuaLS for editing Neovim configs
      'folke/lazydev.nvim',
      ft = 'lua',
      opts = {
        library = {
          { -- Load luvit types when the `vim.uv` word is found
            path = 'luvit-meta/library',
            words = { 'vim%.uv' },
          },
        },
      },
    }, -- folke/lazydev.nvim

    { -- Meta type definitions for the Lua platform Luvit
      'Bilal2453/luvit-meta',
      lazy = true,
    }, -- Bilal2453/luvit-meta

    { -- Main LSP Configuration
      'neovim/nvim-lspconfig',
      dependencies = {
        -- Automatically install LSPs and related tools to stdpath for Neovim
        { -- Installs and manages LSP servers, DAP servers, linters, and formatters
          -- NOTE: MUST be loaded before dependants
          'williamboman/mason.nvim',
          config = true,
        },
        { -- bridges mason.nvim with the lspconfig plugin
          'williamboman/mason-lspconfig.nvim',
        },
        { -- Installs and upgrades third-party tools

          'WhoIsSethDaniel/mason-tool-installer.nvim',
        },
        { -- Extensible UI for Neovim notifications and LSP progress messages
          'j-hui/fidget.nvim',
          opts = {}, -- Forces init at startup
        },

        { -- Allows extra capabilities provided by nvim-cmp
          'hrsh7th/cmp-nvim-lsp',
        },
      },
      opts = {
        inlay_hints = { enabled = true },
      },
      config = function()
        vim.api.nvim_create_autocmd('LspAttach', {
          group = vim.api.nvim_create_augroup('skrynet-lsp-attach', { clear = true }),
          callback = function(attach_event)
            local map = function(keys, func, desc, mode)
              mode = mode or 'n'
              vim.keymap.set(mode, keys, func, { buffer = attach_event.buf, desc = 'LSP: ' .. desc })
            end

            -- Jump to the definition of the word under the cursor
            map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
            -- Jump to the declaration of the word under the cursor
            map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
            -- Find references for the word under the cursor
            map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
            -- Jump to the implementation of the word under the cursor
            map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
            -- Jump to the type of the word under the cursor
            map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')

            -- Display LSP hover text
            map('<leader>k', vim.lsp.buf.hover, '[H]over')
            map('<C-k>', vim.lsp.buf.hover, '[H]over', { 'n', 'i' })

            -- Fuzzy find all the symbols in the current document
            map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
            -- Fuzzy find all the symbols in the current workspace
            map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

            -- Rename the symbol under the cursor
            map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

            -- Execute a code action (usually the cursor needs to be on top of a diagnostic)
            map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })

            -- The following two autocommands are used to highlight references of the
            -- word under your cursor when your cursor rests there for a little while.
            --    See `:help CursorHold` for information about when this is executed
            --
            -- When you move your cursor, the highlights will be cleared (the second autocommand).
            local client = vim.lsp.get_client_by_id(attach_event.data.client_id)
            if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
              local highlight_group = vim.api.nvim_create_augroup('skrynet-lsp-highlight', { clear = false })
              -- Highlight under cursor on hold
              vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                buffer = attach_event.buf,
                group = highlight_group,
                callback = vim.lsp.buf.document_highlight,
              })

              -- Remove highlight under cursor on move
              vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                buffer = attach_event.buf,
                group = highlight_group,
                callback = vim.lsp.buf.clear_references,
              })

              vim.api.nvim_create_autocmd('LspDetach', {
                group = vim.api.nvim_create_augroup('skrynet-lsp-detach', { clear = true }),
                callback = function(detach_event)
                  vim.lsp.buf.clear_references()
                  vim.api.nvim_clear_autocmds { group = 'skrynet-lsp-highlight', buffer = detach_event.buf }
                end,
              })
            end

            -- Toggle inlay hints, if the language server supports them
            if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
              map('<leader>th', function()
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = attach_event.buf })
              end, '[T]oggle Inlay [H]ints')
            end
          end,
        })

        -- Configure diagnostic symbols in the gutter
        local signs = { ERROR = '', WARN = '', INFO = '', HINT = '' }
        local diagnostic_signs = {}
        for type, icon in pairs(signs) do
          diagnostic_signs[vim.diagnostic.severity[type]] = icon
        end
        vim.diagnostic.config { signs = { text = diagnostic_signs } }

        -- Extend LSP capabilities with cmp_nvim_lsp
        local capabilities = vim.tbl_deep_extend(
          'force',
          vim.lsp.protocol.make_client_capabilities(),
          require('cmp_nvim_lsp').default_capabilities()
        )

        -- Enable the following language servers
        local servers = {
          -- server_name = {
          --   cmd = {}, -- Override the default command used to start the server
          --   filetypes = {}, -- Override the default list of associated filetypes for the server
          --   capabilities = {}, -- Override the default settings passed when initializing the server
          -- },
          ansiblels = {},
          clangd = {},
          gopls = {},
          rust_analyzer = {},
          lua_ls = {
            settings = {
              Lua = {
                completion = {
                  callSnippet = 'Replace',
                },
                -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
                diagnostics = { disable = { 'missing-fields' } },
              },
            },
          },
        }
        -- Additional tools
        local tools = {
          'ansible-lint', -- Ansible Linter
          'stylua', -- Used to format Lua code
        }

        -- Ensure the servers and tools above are installed
        require('mason').setup()

        local ensure_installed = vim.tbl_keys(servers or {})
        vim.list_extend(ensure_installed, tools or {})
        require('mason-tool-installer').setup { ensure_installed = ensure_installed }

        require('mason-lspconfig').setup {
          handlers = {
            function(server_name)
              local server = servers[server_name] or {}
              -- Override only explicitly configured features.
              server.capabilities = vim.tbl_deep_extend('force', capabilities or {}, server.capabilities or {})
              require('lspconfig')[server_name].setup(server)
            end,
          },
        }
      end,
    }, -- neovim/nvim-lspconfig

    { -- Autoformat
      'stevearc/conform.nvim',
      event = 'BufWritePre',
      cmd = 'ConformInfo',
      keys = {
        {
          '<leader>f',
          function()
            require('conform').format { async = true, lsp_format = 'fallback' }
          end,
          mode = 'n',
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
          go = { 'goimports' },
          lua = { 'stylua' },
        },
      },
    }, -- stevearc/conform.nvim

    { -- Autocompletion
      'hrsh7th/nvim-cmp',
      event = 'InsertEnter',
      dependencies = {
        { -- Snippet Engine and associated nvim-cmp source
          'L3MON4D3/LuaSnip',
          build = (function()
            -- Build Step is needed for regex support in snippets.
            if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
              return
            end
            return 'make install_jsregexp'
          end)(),
          dependencies = {
            { -- Snippets collection for a set of different programming languages.
              'rafamadriz/friendly-snippets',
              config = function()
                require('luasnip.loaders.from_vscode').lazy_load()
              end,
            },
          },
        },
        { 'saadparwaiz1/cmp_luasnip' },

        -- Add other nvim-cmp capabilities.
        { 'hrsh7th/cmp-nvim-lsp' },
        { 'hrsh7th/cmp-path' },
      },
      config = function()
        -- See `:help cmp`
        local cmp = require 'cmp'
        local luasnip = require 'luasnip'
        luasnip.config.setup {}

        cmp.setup {
          snippet = {
            expand = function(args)
              luasnip.lsp_expand(args.body)
            end,
          },
          completion = { completeopt = 'menu,menuone,noinsert' },

          -- For an understanding of why these mappings were
          -- chosen, you will need to read `:help ins-completion`
          --
          -- No, but seriously. Please read `:help ins-completion`, it is really good!
          mapping = cmp.mapping.preset.insert {
            -- Select the [n]ext item
            ['<C-n>'] = cmp.mapping.select_next_item(),
            -- Select the [p]revious item
            ['<C-p>'] = cmp.mapping.select_prev_item(),

            -- Scroll the documentation window [b]ack / [f]orward
            ['<C-b>'] = cmp.mapping.scroll_docs(-4),
            ['<C-f>'] = cmp.mapping.scroll_docs(4),

            -- Accept the completion
            --  This will auto-import if your LSP supports it.
            --  This will expand snippets if the LSP sent a snippet.
            ['<Tab>'] = cmp.mapping.confirm { select = true },

            -- Manually trigger a completion from nvim-cmp.
            ['<C-Space>'] = cmp.mapping.complete {},

            -- Move through snippets
            -- <C-l> move to the right of each of the expansion locations
            -- <C-h> move to the left  of each of the expansion locations
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
          },
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
        }
      end,
    }, -- hrsh7th/nvim-cmp

    { -- Colorschemes
      'ellisonleao/gruvbox.nvim',
      priority = 1000, -- Make sure to load this before all the other start plugins.
      opts = {
        terminal_colors = true, -- add neovim terminal colors
        undercurl = true,
        underline = true,
        bold = true,
        italic = {
          strings = true,
          emphasis = true,
          comments = true,
          operators = false,
          folds = true,
        },
        strikethrough = true,
        invert_selection = false,
        invert_signs = false,
        invert_tabline = false,
        invert_intend_guides = false,
        inverse = true, -- invert background for search, diffs, statuslines and errors
        contrast = '', -- ['', 'hard', 'soft']
        palette_overrides = {},
        overrides = {
          SignColumn = { bg = '', link = 'GruvboxBg0' },
          Todo = { bg = '', fg = '', bold = false },
          -- ErrorMsg   = { bg = '', fg = '', bold = true },
          -- WarningMsg = { bg = '', fg = '', bold = true },
        },
        dim_inactive = false,
        transparent_mode = false,
      },
      config = function(_, opts)
        require('gruvbox').setup(opts)
        vim.cmd.colorscheme 'gruvbox'
      end,
      init = function() end,
    }, -- ellisonleao/gruvbox.nvim

    { -- Highlight todos, notes, etc. in comments:
      'folke/todo-comments.nvim',
      event = 'VimEnter',
      dependencies = {
        'nvim-lua/plenary.nvim',
      },
      opts = {
        signs = true,
        keywords = {
          FIX = { icon = ' ', color = 'error', alt = { 'FIXME', 'BUG', 'FIXIT' } },
          TODO = { icon = ' ', color = 'info', alt = {} },
          HACK = { icon = ' ', color = 'warning', alt = { 'MESSY' } },
          WARN = { icon = ' ', color = 'warning', alt = {} },
          PERF = { icon = ' ', color = 'info', alt = { 'OPTIMIZE' } },
          NOTE = { icon = ' ', color = 'hint', alt = { 'INFO' } },
          TEST = { icon = ' ', color = 'test', alt = { 'PASSED', 'FAILED' } },
          -- Alt icons: 󰗚 󰂾 󱓷
          DOCS = { icon = '󰗚 ', color = 'hint', alt = { 'DOC', 'DOCUMENTATION', 'SOURCE' } },
        },
      },
    }, -- folke/todo-comments.nvim

    { -- Collection of various small independent plugins/modules
      'echasnovski/mini.nvim',
      config = function()
        -- Better Around/Inside textobjects, i.e.
        --  - va)  - [V]isually select [A]round [)]paren
        --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
        --  - ci'  - [C]hange [I]nside [']quote
        require('mini.ai').setup { n_lines = 500 }

        -- Add/delete/replace surroundings (brackets, quotes, etc.)
        -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
        -- - sd'   - [S]urround [D]elete [']quotes
        -- - sr)'  - [S]urround [R]eplace [)] [']
        require('mini.surround').setup()

        -- Simple and easy statusline.
        local statusline = require 'mini.statusline'
        -- Use nice NerdFont icons
        statusline.setup { use_icons = true }

        -- Display LINE:COLUMN in cursor location only
        ---@diagnostic disable-next-line: duplicate-set-field
        statusline.section_location = function()
          return '%2l:%-2v'
        end
      end,
    },

    { -- Highlight, edit, and navigate code
      'nvim-treesitter/nvim-treesitter',
      build = ':TSUpdate',
      main = 'nvim-treesitter.configs',
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
          'go',
        },
        -- Autoinstall languages that are not installed
        auto_install = true,
        highlight = {
          enable = true,
          -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
          --  If you are experiencing weird indenting issues, add the language to
          --  the list of additional_vim_regex_highlighting and disabled languages for indent.
          additional_vim_regex_highlighting = { 'ruby' },
        },
        indent = { enable = true, disable = { 'ruby' } },
      },
      -- TODO: Explore Treesitter, i.e.
      --  - Incremental selection:     `:help nvim-treesitter-incremental-selection-mod`
      --  - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
      --  - Treesitter + textobjects:  https://github.com/nvim-treesitter/nvim-treesitter-textobjects
    }, -- nvim-treesitter/nvim-treesitter

    { -- Import modularized plugins
      import = 'skrynet.plugins',
    },
  }, -- lazy.setup spec
  { -- lazy.setup opts
    ui = {
      icons = {},
    },
  } -- lazy.setup opts
)

-- vim: ts=2 sts=2 sw=2 et
