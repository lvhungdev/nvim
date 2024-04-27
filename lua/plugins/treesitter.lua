return {
  'nvim-treesitter/nvim-treesitter',
  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects'
  },
  event        = { 'BufReadPre', 'BufNewFile' },
  config       = function()
    require('nvim-treesitter.configs').setup({
      auto_install = true,
      highlight = { enable = true },
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ['af'] = '@function.outer',
            ['if'] = '@function.inner',
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            [']f'] = '@function.outer',
          },
          goto_previous_start = {
            ['[f'] = '@function.outer',
          },
        },
      },
    })
  end
}
