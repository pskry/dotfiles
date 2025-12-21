local opt = vim.opt
opt.scrolloff = 10
opt.sidescrolloff = 12
opt.spelllang = { 'en', 'de', 'da' }
opt.modeline = true
opt.list = true
opt.listchars = {
  tab = '» ',
  trail = '~',
  nbsp = '␣',
  extends = '⟩',
  precedes = '⟨',
  -- space = '·',
  eol = '¬',
}

opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
