local function get_installed_lsp_servers()
  local registry = require('mason-registry')
  local lsp = {}
  for _, pkg_info in ipairs(registry.get_installed_packages()) do
    for _, type in ipairs(pkg_info.spec.categories) do
      if type == 'LSP' then
        lsp[pkg_info.spec.neovim.lspconfig] = true
      end
    end
  end
  return lsp
end

-- default on_attach callback
local on_attach = function(_, bufnr)
  -- wrap diagnostic prev and next so that they can be repeated with ; and ,
  local diag_move = require('nvim-treesitter-textobjects.repeatable_move').make_repeatable_move(function(opts)
    if opts.forward then
      vim.diagnostic.jump({ count = 1 })
    else
      vim.diagnostic.jump({ count = -1 })
    end
  end)

  local opts = { remap = false, silent = true, buffer = bufnr }

  opts.desc = 'Show diagnostic message'
  vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)

  opts.desc = 'Go to previous diagnostic'
  vim.keymap.set('n', '[d', function()
    diag_move({ forward = false })
  end, opts)

  opts.desc = 'Go to next diagnostic'
  vim.keymap.set('n', ']d', function()
    diag_move({ forward = true })
  end, opts)

  opts.desc = 'Open buffer diagnostic in location list'
  vim.keymap.set('n', '<space>d', vim.diagnostic.setloclist, opts)

  opts.desc = 'Open workspace diagnostic in quickfix list'
  vim.keymap.set('n', '<space>D', vim.diagnostic.setqflist, opts)

  opts.desc = 'Go to declaration'
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)

  opts.desc = 'Go to definition'
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)

  opts.desc = 'Go to implementation'
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)

  opts.desc = 'Go to type definition'
  vim.keymap.set('n', '<space>t', vim.lsp.buf.type_definition, opts)

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
          url = 'https://raw.githubusercontent.com/awslabs/goformation/master/schema/cloudformation.schema.json',
        },
        {
          fileMatch = { 'cdk.json' },
          url = 'https://json.schemastore.org/cdk.json',
        },
        {
          fileMatch = { 'package.json' },
          url = 'https://json.schemastore.org/package.json',
        },
      },
    },
  },
  ['yamlls'] = {
    yaml = {
      schemas = {
        ['kubernetes'] = {
          'k8s/*.y{a,}ml',
          '*k8s*.y{a,}ml',
          'pod{s,}.y{a,}ml',
          'deploy{s,}.y{a,}ml',
          'deployment{s,}.y{a,}ml',
          'statefulset{s,}.y{a,}ml',
          'ds{s,}.y{a,}ml',
          'daemonset{s,}.y{a,}ml',
          'job{s,}.y{a,}ml',
          'cronjob{s,}.y{a,}ml',
          'pv{s,}.y{a,}ml',
          'pvc{s,}.y{a,}ml',
          'manifest.y{a,}ml',
        },
        ['https://raw.githubusercontent.com/awslabs/goformation/master/schema/cloudformation.schema.json'] = {
          '*cf.y{a,}ml',
          '*cloudformation.y{a,}ml',
        },
      },
      customTags = {
        '!And',
        '!And sequence',
        '!If',
        '!If sequence',
        '!Not',
        '!Not sequence',
        '!Equals',
        '!Equals sequence',
        '!Or',
        '!Or sequence',
        '!FindInMap',
        '!FindInMap sequence',
        '!Base64',
        '!Join',
        '!Join sequence',
        '!Cidr',
        '!Ref',
        '!Sub',
        '!Sub sequence',
        '!GetAtt',
        '!GetAZs',
        '!ImportValue',
        '!ImportValue sequence',
        '!Select',
        '!Select sequence',
        '!Split',
        '!Split sequence',
      },
    },
  },
  ['rust_analyzer'] = {
    -- weird structure but that's what the server expects
    ['rust-analyzer'] = {
      checkOnSave = {
        allFeatures = true,
        overrideCommand = {
          'cargo',
          'clippy',
          '--workspace',
          '--message-format=json',
          '--all-targets',
          '--all-features',
        },
      },
    },
  },
}

local yaml_companion = require('yaml-companion').setup()
local function yaml_on_attach(client, bufnr)
  yaml_companion.on_attach(client, bufnr)

  -- this is normally added by lspconfig and yaml companion relies on that
  -- (probably to reconfigure the server after changing the yaml schema)
  function client.workspace_did_change_configuration(configuration)
    if not configuration then
      return
    end
    if vim.tbl_isempty(configuration) then
      configuration = { [vim.type_idx] = vim.types.dictionary }
    end
    return client.notify('workspace/didChangeConfiguration', {
      settings = configuration,
    })
  end
end

-- custom on_attach callbacks
--- @type { string: function }
local callbacks = {
  ['yamlls'] = yaml_on_attach,
}

-- merge all the on_attach functions:
--  - the original on_attach defined in nvim-lspconfig (if defined)
--  - the generic on_attach defined at the top of this file
--  - the specific language server on_attach callback (if defined)
local function merge_on_attach(server_name)
  local orig_on_attach = vim.lsp.config[server_name].on_attach

  return function(client, bufnr)
    if orig_on_attach then
      orig_on_attach(client, bufnr)
    end
    on_attach(client, bufnr)
    if callbacks[server_name] then
      callbacks[server_name](client, bufnr)
    end
  end
end

local installed_servers = get_installed_lsp_servers()

for name, _ in pairs(installed_servers) do
  vim.lsp.config(name, {
    on_attach = merge_on_attach(name),
    settings = settings[name] or {},
  })

  vim.lsp.enable(name)
end

-- add command to reload the LSP server settings
vim.api.nvim_create_user_command('LspConfigReload', function()
  local module = 'config.lspconfig'
  package.loaded[module] = nil
  require(module)
end, {})

-- add command to detach LSP clients from active buffer
vim.api.nvim_create_user_command('LspBufDetach', function()
  for id, _ in pairs(vim.lsp.get_clients()) do
    vim.lsp.buf_detach_client(0, id)
  end
end, { bar = true })
