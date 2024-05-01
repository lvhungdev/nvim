Keymap('n', 'K', vim.lsp.buf.hover, MapOpts)
Keymap('n', 'gd', ':Telescope lsp_definitions<cr>', MapOpts)
Keymap('n', 'gr', ':Telescope lsp_references<cr>', MapOpts)
Keymap('n', 'gi', ':Telescope lsp_implementations<cr>', MapOpts)
Keymap('n', '<leader>sd', ':Telescope diagnostics<cr>', MapOpts)
Keymap('n', '<leader>so', ':Telescope lsp_document_symbols<cr>', MapOpts)
Keymap('n', '<leader>sO', ':Telescope lsp_dynamic_workspace_symbols<cr>', MapOpts)
Keymap('n', '<leader>a', vim.lsp.buf.code_action, MapOpts)
Keymap('n', '<leader>r', vim.lsp.buf.rename, MapOpts)
Keymap('n', '<leader>ls', vim.lsp.buf.signature_help, MapOpts)
Keymap('n', '<leader>lf', function() vim.lsp.buf.format { async = true } end, MapOpts)
Keymap('v', '<leader>lf',
  function()
    vim.lsp.buf.format({
      async = true,
      range = { ['start'] = vim.api.nvim_buf_get_mark(0, '<'), ['end'] = vim.api.nvim_buf_get_mark(0, '>') }
    })
  end,
  MapOpts)
Keymap('n', 'J', vim.diagnostic.open_float, MapOpts)
Keymap('n', '[d', vim.diagnostic.goto_prev, MapOpts)
Keymap('n', ']d', vim.diagnostic.goto_next, MapOpts)

return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
    },
    event = { 'BufReadPre', 'BufNewFile' },
    cmd = { 'Mason' },
    config = function()
      require('mason').setup()
      require('mason-lspconfig').setup()

      local lspconfig = require('lspconfig')
      lspconfig.lua_ls.setup({})
      lspconfig.dartls.setup({
        settings = {
          dart = { lineLength = 120 }
        }
      })
      lspconfig.gopls.setup({
        settings = {
          gopls = { semanticTokens = true },
        },
      })
      lspconfig.tsserver.setup({})
      lspconfig.rust_analyzer.setup({})
      lspconfig.omnisharp.setup({})
      lspconfig.clangd.setup({})
    end
  },

  {
    'jose-elias-alvarez/null-ls.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local null_ls = require('null-ls')
      null_ls.setup({
        sources = {
          null_ls.builtins.formatting.prettier,
          null_ls.builtins.diagnostics.eslint_d,
          null_ls.builtins.code_actions.eslint_d,
          null_ls.builtins.formatting.csharpier,
        }
      })
    end
  }
}
