-- Setup nvim-cmp.
local cmp = require('cmp')
local types = require('cmp.types')
local feedkeys = require('cmp.utils.feedkeys')
local keymap = require('cmp.utils.keymap')

cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      vim.fn['vsnip#anonymous'](args.body) -- For `vsnip` users.
      -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
      -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
      -- vim.fn['UltiSnips#Anon'](args.body) -- For `ultisnips` users.
    end,
  },
  window = {
    -- completion = cmp.config.window.bordered(),
    -- documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    -- revert the behavior of https://github.com/hrsh7th/nvim-cmp/commit/53f49c5145d05a53b997d3f647f97e5ac8e9bd5c
    -- so that you can actually trigger the native vim <C-p> and <C-n> complete menu (:h complete)
    -- when the cmp menu is not visible
    ['<C-n>'] = cmp.mapping.select_next_item({ behavior = types.cmp.SelectBehavior.Insert }),
    ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = types.cmp.SelectBehavior.Insert }),
    -- scroll documentation
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    -- open the cmp menu manually
    ['<C-Space>'] = cmp.mapping.complete({}),
    -- close the cmp menu and abort completion: useful to trigger native menu with <C-p> and <C-n>
    -- or when you don't want to complete (as <CR> will select the completion item automatically)
    ['<C-e>'] = cmp.mapping.abort(),
    -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' }, -- For vsnip users.
    -- { name = 'luasnip' }, -- For luasnip users.
    -- { name = 'ultisnips' }, -- For ultisnips users.
    -- { name = 'snippy' }, -- For snippy users.
  }, {
    { name = 'buffer' },
    { name = 'path' },
  }),
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' },
  },
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  -- https://github.com/hrsh7th/nvim-cmp/pull/1445#issuecomment-1442071031
  mapping = cmp.mapping.preset.cmdline({
    ['<Tab>'] = {
      c = function(_)
        if cmp.visible() then
          cmp.select_next_item()
        else
          feedkeys.call(keymap.t('<C-z>'), 'n')
        end
      end,
    },
    ['<S-Tab>'] = {
      c = function()
        if cmp.visible() then
          cmp.select_prev_item()
        else
          feedkeys.call(keymap.t('<C-z>'), 'n')
        end
      end,
    },
  }),
  sources = cmp.config.sources({
    { name = 'path' },
  }, {
    {
      name = 'cmdline',
      option = {
        ignore_cmds = { '!', 'Man' },
      },
    },
  }),
})

cmp.setup.filetype('neorepl', {
  enabled = false,
})
