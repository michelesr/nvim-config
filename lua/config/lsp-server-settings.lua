-- LSP server settings
--
-- you should bookmark this file, e.g. mS
-- and then jump to it with `S or 'S
--
-- use :LspConfigReload to reload config after making changes

local lspconfig = require('lspconfig')
local installed_list = require('mason-lspconfig').get_installed_servers()
-- create a lookup table for the installed servers
local installed = {}
for _, v in ipairs(installed_list) do
  installed[v] = true
end

-- call setup() only for installed servers
local function cond_setup(name, config)
  if installed[name] then
    lspconfig[name].setup(config)
  end
end

cond_setup('jsonls', {
  settings = {
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
  }
})

cond_setup('yamlls', {
  settings = {
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
  }
})

cond_setup('rust_analyzer', {
  settings = {
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
})
