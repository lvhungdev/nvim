Keymap('t', '<C-x>', '<C-\\><C-n>', MapOpts)

vim.cmd('autocmd TermOpen * startinsert')
vim.cmd('autocmd TermOpen * setlocal nonumber norelativenumber')
vim.cmd('autocmd TermClose * lua vim.api.nvim_input("<cr>")')

return {}
