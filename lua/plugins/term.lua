Keymap('t', '<C-x>', '<C-\\><C-n>', MapOpts)

-- vim.cmd('autocmd TermOpen * startinsert')

vim.api.nvim_create_autocmd({ 'TermOpen' }, {
  pattern = { '*' },
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
  end
})

vim.api.nvim_create_autocmd({ 'TermClose' }, {
  pattern = { '*' },
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.api.nvim_input('<cr>')
  end
})

return {}
