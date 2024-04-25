return {
  { 'windwp/nvim-autopairs', event = { 'InsertEnter' },             opts = {} },
  { 'tpope/vim-surround',    event = { 'BufReadPre', 'BufNewFile' } },
  {
    'numToStr/Comment.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      require('Comment').setup({})

      Keymap('n', '<leader>/', 'gcc', { remap = true, silent = true })
      Keymap('v', '<leader>/', 'gc', { remap = true, silent = true })
    end
  },
}
