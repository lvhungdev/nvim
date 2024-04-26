Keymap('n', '<leader>f', ':Telescope find_files<cr>', MapOpts)
Keymap('n', '<leader>w', ':Telescope live_grep<cr>', MapOpts)
Keymap('n', '<leader>p', ':Telescope buffers<cr>', MapOpts)
Keymap('n', '<leader>sh', ':Telescope help_tags<cr>', MapOpts)

Keymap('n', '<leader>e', ':NvimTreeToggle<cr>', MapOpts)

return {
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim' },
    cmd = 'Telescope',
    config = function()
      local telescope_actions = require('telescope.actions')
      require('telescope').setup({
        defaults = {
          layout_strategy = 'horizontal',
          layout_config = {
            horizontal = { prompt_position = 'top' },
          },
          sorting_strategy = 'ascending',
          mappings = {
            i = {
              ['<esc>'] = telescope_actions.close,
              ['<c-x>'] = telescope_actions.delete_buffer,
            },
          },
          borderchars = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
          path_display = { 'truncate' },
        },
      })
    end
  },

  {
    'nvim-tree/nvim-tree.lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    cmd = 'NvimTreeToggle',
    config = function()
      require('nvim-tree').setup({
        filters = { dotfiles = false },
        disable_netrw = true,
        hijack_netrw = true,
        hijack_cursor = true,
        sync_root_with_cwd = true,
        update_focused_file = { enable = true },
        view = {
          adaptive_size = false,
          side = 'right',
          width = 40,
        },
        git = { timeout = 2500 },
        actions = {
          open_file = {
            resize_window = true,
            window_picker = { enable = false },
          },
        },
        diagnostics = { enable = true },
        renderer = {
          highlight_git = true,
          highlight_opened_files = 'none',
          indent_markers = { enable = false },
          full_name = true,
          group_empty = true,
          special_files = {},
          icons = {
            show = {
              file = true,
              folder = false,
              folder_arrow = true,
              git = false,
            },
          },
        },
      })
    end,
  }
}
