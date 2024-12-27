-- Setup nvim-cmp.
local cmp = require('cmp')
local types = require('cmp.types')
local feedkeys = require('cmp.utils.feedkeys')
local keymap = require('cmp.utils.keymap')
local luasnip = require('luasnip')

-- patch the feedkeys function to prevent unwanted changes to the bs option
local fk_mt = getmetatable(feedkeys.call)
local orig_f = fk_mt.__call
local function patched_feedkeys(self, keys, mode, callback)
  local bs = vim.go.backspace
  local ok, err = pcall(function()
    orig_f(self, keys, mode, callback)
  end)
  if vim.go.backspace ~= bs then
    vim.notify('Detected undesired value of backspace: ' .. vim.go.backspace)
    vim.notify('Restoring backspace option to ' .. bs)
    vim.go.backspace = bs
  end
  if not ok then
    error(err)
  end
end
fk_mt.__call = patched_feedkeys

cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      luasnip.lsp_expand(args.body)
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
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' }, -- For luasnip users.
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
