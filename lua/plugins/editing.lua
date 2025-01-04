Keymap('n', '<leader>/', 'gcc', { remap = true, silent = true })
Keymap('v', '<leader>/', 'gc', { remap = true, silent = true })

return {
  { 'windwp/nvim-autopairs', event = { 'InsertEnter' },             opts = {} },
  { 'tpope/vim-surround',    event = { 'BufReadPre', 'BufNewFile' } },
}
