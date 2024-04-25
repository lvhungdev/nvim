return {
  'hrsh7th/nvim-cmp',
  dependencies = {
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-nvim-lsp-signature-help',
    'L3MON4D3/LuaSnip',
    'saadparwaiz1/cmp_luasnip',
    'rafamadriz/friendly-snippets',
  },
  event = { 'InsertEnter' },
  config = function()
    local cmp = require('cmp')
    local ls = require('luasnip')

    cmp.setup({
      snippet = {
        expand = function(args) ls.lsp_expand(args.body) end
      },
      mapping = cmp.mapping.preset.insert({
        ['<c-u>'] = cmp.mapping.scroll_docs(-4),
        ['<c-d>'] = cmp.mapping.scroll_docs(4),
        ['<c-space>'] = cmp.mapping.complete(),
        ['<tab>'] = cmp.mapping.confirm {
          behavior = cmp.ConfirmBehavior.Replace,
          select = true,
        },
      }),
      sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'nvim_lsp_signature_help' },
        { name = 'luasnip' },
      })
    })

    require("luasnip.loaders.from_vscode").lazy_load()

    Keymap({ 'i', 's' }, '<c-.>', function() ls.jump(1) end, MapOpts)
    Keymap({ 'i', 's' }, '<c-,>', function() ls.jump(-1) end, MapOpts)
  end

}
