local on_attach = function(client, bufnr)
  -- disable LSP on Helm templates until supported
  if vim.bo[bufnr].filetype == 'helm' then
    print('Helm template not supported: detaching LSP client')
    vim.lsp.buf_detach_client(bufnr, client.id)
    return
  end

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

-- server settings
local settings = {
  ['jsonls'] = {
    json = {
      -- type gf to open the url and look at the scheme catalog:
      --   https://www.schemastore.org/api/json/catalog.json
      schemas = {
        {
          fileMatch = {
            '*cf.json',
            '*cloudformation.json',
            'cdk.out/*.template.json',
          },
          url = 'https://raw.githubusercontent.com/awslabs/goformation/master/schema/cloudformation.schema.json'
        },
        {
          fileMatch = {'cdk.json'},
          url = 'https://json.schemastore.org/cdk.json'
        },
        {
          fileMatch = {'package.json'},
          url = 'https://json.schemastore.org/package.json',
        },
      }
    }
  },
  ['yamlls'] = {
    yaml = {
      schemas = {
        ['kubernetes'] = 'foo.yaml',
        ['https://raw.githubusercontent.com/awslabs/goformation/master/schema/cloudformation.schema.json'] = {
          '*cf.yaml',
          '*cloudformation.yaml',
        }
      },
      customTags = {
        '!Ref scalar',
        '!Split sequence',
        '!GetAtt',
      }
    }
  },
  'rust_analyzer', {
    ['rust-analyzer'] = {
      checkOnSave = {
        allFeatures = true,
        overrideCommand = {
          'cargo', 'clippy', '--workspace', '--message-format=json',
          '--all-targets', '--all-features'
        }
      }
    }
  }
}

-- Setup lspconfig.
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

require('mason-lspconfig').setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = settings[server_name]
    }
  end,
}

-- add command to reload the LSP server settings
vim.api.nvim_create_user_command('LspConfigReload', function()
  local module = 'config.lspconfig'
  package.loaded[module] = nil
  require(module)
end, {})

-- add command to detach LSP clients from active buffer
vim.api.nvim_create_user_command('LspBufDetach', function()
  for id, _ in pairs(vim.lsp.buf_get_clients()) do
    vim.lsp.buf_detach_client(0, id)
  end
end, {})
