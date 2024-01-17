local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
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
  -- { 'Mofiqul/vscode.nvim' },
  -- { 'lunarvim/darkplus.nvim' },
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

  -- IDE
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      -- 'Hoffs/omnisharp-extended-lsp.nvim',
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
  { 'jose-elias-alvarez/null-ls.nvim' },
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'rcarriga/nvim-dap-ui',
    }
  },
  { 'lewis6991/gitsigns.nvim',        opts = {} },
  { 'nvim-treesitter/nvim-treesitter' },
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
      i = {
        ['<Esc>'] = telescope_actions.close,
        ['<C-x>'] = telescope_actions.delete_buffer,
      },
    },
    borderchars = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
    path_display = { 'tail', 'truncate' },
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
lspconfig.tsserver.setup({})
lspconfig.rust_analyzer.setup({})
lspconfig.omnisharp.setup({
  cmd = { 'dotnet', vim.fn.stdpath('data') .. '/mason/packages/omnisharp/libexec/OmniSharp.dll' },
  -- handlers = {
  --   ["textDocument/definition"] = require('omnisharp_extended').handler,
  -- },
  organize_imports_on_format = true,
  enable_roslyn_analyzers = true,
})

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

local null_ls = require('null-ls')
null_ls.setup({
  sources = {
    null_ls.builtins.formatting.prettier,
    null_ls.builtins.diagnostics.eslint_d,
    null_ls.builtins.code_actions.eslint_d,
    null_ls.builtins.formatting.csharpier,
  }
})

require('dapui').setup()
local dap, dapui = require('dap'), require('dapui')
dap.listeners.before.attach.dapui_config = function() dapui.open() end
dap.listeners.before.launch.dapui_config = function() dapui.open() end
dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
dap.listeners.before.event_exited.dapui_config = function() dapui.close() end

dap.adapters.codelldb = {
  type = 'server',
  port = '${port}',
  executable = {
    command = vim.fn.stdpath('data') .. '/mason/bin/codelldb',
    args = { '--port', '${port}' },
  }
}
dap.configurations.rust = {
  {
    name = 'Launch file',
    type = 'codelldb',
    request = 'launch',
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/target/debug/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopAtEntry = true,
  },
}

require('nvim-treesitter.configs').setup({
  auto_install = true,
  highlight = { enable = true }
})

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
keymap('n', '<C-e>', ':Telescope buffers<cr>', opts)
keymap('n', '<leader>ld', ':Telescope diagnostics<cr>', opts)

keymap('n', '<leader>e', ':NvimTreeToggle<cr>', opts)

keymap('n', 'K', vim.lsp.buf.hover, opts)
keymap('n', 'J', vim.diagnostic.open_float, opts)
keymap('n', 'gD', vim.lsp.buf.declaration, opts)
keymap('n', 'gd', vim.lsp.buf.definition, opts)
keymap('n', 'gi', vim.lsp.buf.implementation, opts)
keymap('n', 'gr', vim.lsp.buf.references, opts)
keymap('n', '[d', vim.diagnostic.goto_prev, opts)
keymap('n', ']d', vim.diagnostic.goto_next, opts)
keymap('n', '<leader>ls', vim.lsp.buf.signature_help, opts)
keymap('n', '<leader>r', vim.lsp.buf.rename, opts)
keymap('n', '<leader>a', vim.lsp.buf.code_action, opts)
keymap('n', '<leader>lf', function() vim.lsp.buf.format { async = true } end, opts)
keymap('v', '<leader>lf',
  function() vim.lsp.buf.format { async = true, range = { ['start'] = vim.api.nvim_buf_get_mark(0, '<'), ['end'] = vim.api.nvim_buf_get_mark(0, '>') } } end,
  opts
)

keymap('n', '<leader>db', ':DapToggleBreakpoint<CR>', opts)
keymap('n', '<leader>dc', ':DapContinue<CR>', opts)
keymap('n', '<leader>dt', ':DapTerminate<CR>', opts)
keymap('n', '<leader>dn', ':DapStepOver<CR>', opts)
keymap('n', '<leader>di', ':DapStepInto<CR>', opts)
keymap('n', '<leader>do', ':DapStepOut<CR>', opts)

keymap('n', '<leader>gp', ':Gitsigns preview_hunk<CR>', opts)
keymap('n', '<leader>gl', ':Gitsigns blame_line<CR>', opts)
keymap('n', '<leader>gr', ':Gitsigns reset_hunk<CR>', opts)
keymap('n', '<leader>gR', ':Gitsigns reset_buffer<CR>', opts)
keymap('n', ']g', ':Gitsigns next_hunk<CR>', opts)
keymap('n', '[g', ':Gitsigns prev_hunk<CR>', opts)

keymap('t', '<C-x>', '<C-\\><C-n>', opts)

-- Options
vim.cmd.colorscheme 'habamax'
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
vim.opt.updatetime = 1000
vim.opt.timeoutlen = 750
vim.opt.termguicolors = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.wrap = false

vim.cmd [[
augroup highlight_yank
    autocmd!
    au TextYankPost * silent! lua vim.highlight.on_yank{higroup="IncSearch", timeout=200}
augroup END
]]

-- Highlights for habamax colorscheme
vim.api.nvim_set_hl(0, 'GitSignsChange', { bg = '#1C1C1C', fg = '#5F87AF' })
vim.api.nvim_set_hl(0, 'WinSeparator', { bg = '#1C1C1C' })
