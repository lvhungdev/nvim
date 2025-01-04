vim.cmd.colorscheme('habamax')
vim.api.nvim_set_hl(0, 'GitSignsChange', { bg = 'none', fg = '#5f87af' })
vim.api.nvim_set_hl(0, 'GitSignsAdd', { bg = 'none', fg = '#87af87' })
vim.api.nvim_set_hl(0, 'WinSeparator', { bg = 'none' })
vim.api.nvim_set_hl(0, '@lsp.type.function', { fg = '#5F8787' })

return {}
