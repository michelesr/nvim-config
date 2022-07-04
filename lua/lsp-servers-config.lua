-- LSP server settings
--
-- you should bookmark this file, e.g. mS
-- and then jump to it with `S or 'S
--
-- use :LspConfigReload to reload config after making changes

local lspconfig = require('lspconfig')

lspconfig['jsonls'].setup{
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
}

lspconfig['yamlls'].setup{
  settings = {
    yaml = {
      schemas = {
        ['kubernetes'] = 'foo.yaml',
        ['https://raw.githubusercontent.com/awslabs/goformation/master/schema/cloudformation.schema.json'] = {
          '*cf.yaml',
          '*cloudformation.yaml',
        }
      }
    }
  }
}
