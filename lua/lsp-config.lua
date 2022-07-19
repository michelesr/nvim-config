-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  -- vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local opts = { noremap=true, silent=true, buffer=bufnr }

  opts.desc = 'Show diagnostic message'
  vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)

  opts.desc = 'Go to previous diagnostic'
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)

  opts.desc = 'Go to next diagnostic'
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)

  opts.desc = 'Open diagnostic list'
  vim.keymap.set('n', '<space>d', vim.diagnostic.setloclist, opts)

  opts.desc = 'Go to declaration'
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)

  opts.desc = 'Go to definition'
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)

  opts.desc = 'Go to implementation'
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)

  opts.desc = 'Go to type definition'
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)

  opts.desc = 'Describe item'
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)

  opts.desc = 'Show signature help'
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)

  opts.desc = 'Add workspace folder'
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)

  opts.desc = 'Remove workspace folder'
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)

  opts.desc = 'List workspace folders'
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, opts)

  opts.desc = 'Rename item'
  vim.keymap.set('n', '<space>R', vim.lsp.buf.rename, opts)

  opts.desc = 'Code actions'
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, opts)

  opts.desc = 'Show references'
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)

  opts.desc = 'Format code'
  vim.keymap.set('n', '<space>F', vim.lsp.buf.formatting, opts)
end

-- Setup lspconfig.
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

local lsp_installer = require('nvim-lsp-installer')
local lspconfig = require('lspconfig')

-- 1. Set up nvim-lsp-installer first!
lsp_installer.setup {
    automatic_installation = true
}

-- 2. (optional) Override the default configuration to be applied to all servers.
lspconfig.util.default_config = vim.tbl_extend(
    'force',
    lspconfig.util.default_config,
    {
        on_attach = on_attach,
        capabilities = capabilities
    }
)

-- 3. Loop through all of the installed servers and set it up via lspconfig
for _, server in ipairs(lsp_installer.get_installed_servers()) do
  lspconfig[server.name].setup {}
end
