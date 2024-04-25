local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
  })
end
vim.opt.rtp:prepend(lazypath)

Keymap = vim.keymap.set
MapOpts = { noremap = true, silent = true }

require('lazy').setup('plugins', {})
