Keymap('n', '<leader>gp', ':Gitsigns preview_hunk<CR>', MapOpts)
Keymap('n', '<leader>gl', ':Gitsigns blame_line<CR>', MapOpts)
Keymap('n', '<leader>gr', ':Gitsigns reset_hunk<CR>', MapOpts)
Keymap('n', '<leader>gR', ':Gitsigns reset_buffer<CR>', MapOpts)
Keymap('n', ']g', ':Gitsigns next_hunk<CR>', MapOpts)
Keymap('n', '[g', ':Gitsigns prev_hunk<CR>', MapOpts)

return {
  'lewis6991/gitsigns.nvim',
  opts = {},
}
