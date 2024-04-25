vim.cmd.colorscheme('habamax')
vim.api.nvim_set_hl(0, 'GitSignsChange', { bg = '#1C1C1C', fg = '#5F87AF' })
vim.api.nvim_set_hl(0, 'GitSignsAdd', { bg = '#1C1C1C', fg = '#87af87' })
vim.api.nvim_set_hl(0, 'WinSeparator', { bg = '#1C1C1C' })

return {
  -- {
  --   'catppuccin/nvim',
  --   name = 'catppuccin',
  --   config = function()
  --     require('catppuccin').setup({
  --       no_italic = true,
  --     })
  --
  --     vim.cmd.colorscheme('catppuccin')
  --   end
  -- },

  {
    'nvim-treesitter/nvim-treesitter',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      require('nvim-treesitter.configs').setup({
        auto_install = true,
        highlight = { enable = true }
      })
    end
  },
}
