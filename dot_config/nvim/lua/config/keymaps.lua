-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local set = vim.keymap.set
local del = vim.keymap.del

del('n', '<leader>l')
del('n', '<leader>L')

-- stylua: ignore
set('n', '<leader>l', function() LazyVim.format { force = true } end, { desc = 'Format Buffer' })

del({ 'i', 'x', 'n', 's' }, '<C-s>')
set('n', '<leader>bw', '<cmd>w<cr><esc>', { desc = 'Write Buffer' })
set('n', '<leader>bR', '<cmd>edit!<cr><esc>', { desc = 'Reload Buffer from Disk' })

-- stylua: ignore start
set({ 'n', 'i' }, '<M-/>', function() vim.cmd 'normal gccj' end, { desc = 'Toggle comment line' })
set('v',          '<M-/>', function() vim.cmd 'normal gcgv' end, { desc = 'Toggle comment' })
-- stylua: ignore end
