-- Setup nvim-cmp.
local cmp = require('cmp')
local types = require('cmp.types')
local feedkeys = require('cmp.utils.feedkeys')
local keymap = require('cmp.utils.keymap')
local luasnip = require('luasnip')

-- patch the feedkeys function to prevent unwanted changes to the options
local fk_mt = getmetatable(feedkeys.call)
local orig_f = fk_mt.__call
local function patched_feedkeys(self, keys, mode, callback)
  -- key is option name, value is {table, current_value}
  local opts = {
    backspace = { vim.go, vim.go.backspace },
    lazyredraw = { vim.go, vim.go.lazyredraw },
    textwidth = { vim.bo, vim.bo.textwidth },
  }

  local ok, err = pcall(function()
    orig_f(self, keys, mode, callback)
  end)

  local ag_name = 'NvimCmpFeedKeysHacks'

  -- run this after all the input has been processed
  local function restore()
    for k, v in pairs(opts) do
      local table, value = v[1], v[2]

      if table[k] ~= value then
        vim.notify(string.format('Restoring option %s: %s -> %s', k, table[k], value))
        table[k] = value
      end
    end

    vim.api.nvim_del_augroup_by_name(ag_name)
  end

  -- if there isn't already, register an autocmd that will attempt restore after
  local _, ag_err = pcall(function()
    vim.api.nvim_get_autocmds({ group = ag_name })
  end)
  if ag_err and string.match(ag_err, string.format("Invalid 'group': '%s'", ag_name)) then
    vim.api.nvim_create_augroup(ag_name, { clear = true })
    vim.api.nvim_create_autocmd({ 'SafeState' }, { group = ag_name, callback = restore })
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
