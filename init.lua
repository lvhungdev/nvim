local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- Plugins
require('lazy').setup({
  -- Editing
  { 'Mofiqul/vscode.nvim' },
  { 'windwp/nvim-autopairs', event = 'InsertEnter', opts = {} },
  { 'tpope/vim-surround', },
  { 'ggandor/leap.nvim' },
  { 'numToStr/Comment.nvim', opts = {} },

  -- Navigations
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim' },
    cmd = 'Telescope',
  },
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      filters = { dotfiles = false },
      disable_netrw = true,
      hijack_netrw = true,
      hijack_cursor = true,
      hijack_unnamed_buffer_when_opening = false,
      sync_root_with_cwd = true,
      update_focused_file = {
        enable = true,
        update_root = false,
      },
      view = {
        adaptive_size = false,
        side = 'right',
        width = 40,
      },
      git = {
        enable = true,
        timeout = 2500,
        -- ignore = true,
      },
      filesystem_watchers = { enable = true },
      actions = {
        open_file = { resize_window = true },
      },
      diagnostics = { enable = true },
      renderer = {
        highlight_git = true,
        highlight_opened_files = 'none',
        indent_markers = { enable = false },
        full_name = true,
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
    },
    cmd = 'NvimTreeToggle'
  },
  {
    'romgrk/barbar.nvim',
    opts = { animation = false },
  },

  -- IDE
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
    },
  },
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-nvim-lsp-signature-help',
      'L3MON4D3/LuaSnip',
    },
    event = 'InsertEnter',
  },
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signcolumn          = true,
      watch_gitdir        = {
        interval = 1000,
        follow_files = true
      },
      attach_to_untracked = true,
      sign_priority       = 6,
      update_debounce     = 100,
      max_file_length     = 40000, -- Disable if file is longer than this (in lines)
      yadm                = {
        enable = false
      },
    },
  },
  { 'akinsho/toggleterm.nvim' },
})

-- Setups
local leap = require('leap')
leap.opts.labels = {
  's', 'f', 'n',
  'j', 'k', 'l', 'h', 'o', 'd', 'w', 'e', 'i', 'm', 'b', 'u',
  'y', 'v', 'r', 'g', 't', 'a', 'q', 'p', 'c', 'x', 'z',
}

local telescope_actions = require('telescope.actions')
require('telescope').setup({
  defaults = {
    layout_strategy = 'horizontal',
    layout_config = {
      horizontal = { prompt_position = 'top' },
    },
    sorting_strategy = 'ascending',
    mappings = {
      i = { ['<esc>'] = telescope_actions.close },
    },
    borderchars = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
  },
})

require('mason').setup()
require('mason-lspconfig').setup()

local lspconfig = require('lspconfig')
lspconfig.lua_ls.setup({})
lspconfig.dartls.setup({
  settings = {
    dart = { lineLength = 120 }
  }
})
lspconfig.gopls.setup({})

local cmp = require('cmp')
cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-d>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'nvim_lsp_signature_help' }
  }, {
  })
})

local term = require('toggleterm')
term.setup({ open_mapping = [[<M-1>]] })

-- Keymaps
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

keymap('', '<Space>', '<Nop>', opts)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

keymap('n', 'c', '"_c', opts)
keymap('n', 'C', '"_C', opts)
keymap('n', 'd', '"_d', opts)
keymap('n', 'D', '"_D', opts)
keymap('n', 'dd', '"_dd', opts)
keymap('v', 'd', '"_d', opts)
keymap('v', 'p', '"_dP', opts)

keymap('n', '<C-h>', '<C-w>h', opts)
keymap('n', '<C-j>', '<C-w>j', opts)
keymap('n', '<C-k>', '<C-w>k', opts)
keymap('n', '<C-l>', '<C-w>l', opts)

keymap('n', '<C-Up>', ':resize +2<CR>', opts)
keymap('n', '<C-Down>', ':resize -2<CR>', opts)
keymap('n', '<C-Left>', ':vertical resize -2<CR>', opts)
keymap('n', '<C-Right>', ':vertical resize +2<CR>', opts)

keymap('n', '<ESC>', ':noh<CR>', opts)

keymap('n', '<', '<gv', opts)
keymap('n', '>', '>gv', opts)
keymap('v', '<', '<gv', opts)
keymap('v', '>', '>gv', opts)

keymap('n', '<A-j>', ':m .+1<CR>==', opts)
keymap('n', '<A-k>', ':m .-2<CR>==', opts)
keymap('v', '<A-j>', ':m .+1<CR>==', opts)
keymap('v', '<A-k>', ':m .-2<CR>==', opts)
keymap('x', '<A-j>', ":move '>+1<CR>gv-gv", opts)
keymap('x', '<A-k>', ":move '<-2<CR>gv-gv", opts)

keymap('n', 's', function()
  local current_window = vim.fn.win_getid()
  require('leap').leap({ target_windows = { current_window } })
end)

keymap('x', 's', function()
  local current_window = vim.fn.win_getid()
  require('leap').leap({ target_windows = { current_window } })
end)

keymap('n', '<leader>/', 'gcc', { remap = true, silent = true })
keymap('v', '<leader>/', 'gc', { remap = true, silent = true })

keymap('n', '<leader>f', ':Telescope find_files<cr>', opts)
keymap('n', '<leader>w', ':Telescope live_grep<cr>', opts)
keymap('n', '<leader>ld', ':Telescope diagnostics<cr>', opts)

keymap('n', '<leader>e', ':NvimTreeToggle<cr>', opts)

keymap('n', '<tab>', ':BufferNext<CR>', opts)
keymap('n', '<S-tab>', ':BufferPrevious<CR>', opts)
keymap('n', '<leader>q', ':BufferClose<CR>', opts)

keymap('n', 'K', vim.lsp.buf.hover, opts)
keymap('n', 'J', vim.diagnostic.open_float, opts)
keymap('n', 'gD', vim.lsp.buf.declaration, opts)
keymap('n', 'gd', ':Telescope lsp_definitions<CR>', opts)
keymap('n', 'gi', ':Telescope lsp_implementations<CR>', opts)
keymap('n', 'gr', ':Telescope lsp_references<CR>', opts)
keymap('n', '[d', vim.diagnostic.goto_prev, opts)
keymap('n', ']d', vim.diagnostic.goto_next, opts)
keymap('n', '<leader>ls', vim.lsp.buf.signature_help, opts)
keymap('n', '<leader>D', vim.lsp.buf.type_definition, opts)
keymap('n', '<leader>r', vim.lsp.buf.rename, opts)
keymap('n', '<leader>a', vim.lsp.buf.code_action, opts)
keymap('n', '<leader>lg', vim.diagnostic.setloclist, opts)
keymap('n', '<leader>lf', function() vim.lsp.buf.format { async = true } end, opts)
keymap('v', '<leader>lf',
  function() vim.lsp.buf.format { async = true, range = { ['start'] = vim.api.nvim_buf_get_mark(0, '<'), ['end'] = vim.api.nvim_buf_get_mark(0, '>') } } end,
  opts
)

keymap('n', '<leader>gp', ':Gitsigns preview_hunk<CR>', opts)
keymap('n', '<leader>gl', ':Gitsigns blame_line<CR>', opts)
keymap('n', '<leader>gr', ':Gitsigns reset_hunk<CR>', opts)
keymap('n', '<leader>gR', ':Gitsigns reset_buffer<CR>', opts)

keymap('t', '<C-x>', '<C-\\><C-n>', opts)
keymap('n', '<leader>tf', ':ToggleTerm direction=float<CR>', opts)

---@diagnostic disable-next-line: lowercase-global
function _lazygit_toggle()
  local Terminal = require('toggleterm.terminal').Terminal
  local lazygit = Terminal:new {
    cmd = 'lazygit',
    hidden = true,
    direction = 'float',
    on_open = function(_)
      vim.cmd 'startinsert!'
    end,
    on_close = function(_) end,
    count = 99,
  }
  lazygit:toggle()
end

---@diagnostic disable-next-line: lowercase-global
function _terminal_two_toggle()
  local Terminal = require('toggleterm.terminal').Terminal
  local term_2 = Terminal:new {
    cmd = nil,
    hidden = true,
    direction = 'horizontal',
    on_open = function(_)
      vim.cmd 'startinsert!'
    end,
    on_close = function(_) end,
    count = 100,
  }
  term_2:toggle()
end

vim.keymap.set('n', '<leader>gu', '<cmd>lua _lazygit_toggle()<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<M-2>', '<cmd>lua _terminal_two_toggle()<CR>', { noremap = true, silent = true })

-- Options
vim.cmd.colorscheme 'vscode'
vim.opt.backup = false
vim.opt.clipboard = 'unnamedplus'
vim.opt.ignorecase = true
vim.opt.expandtab = true
vim.opt.cursorline = true
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.numberwidth = 4
vim.opt.signcolumn = 'yes'
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 4
vim.opt.foldmethod = 'indent'
vim.opt.foldlevel = 99
vim.opt.laststatus = 3
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.termguicolors = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.wrap = false
