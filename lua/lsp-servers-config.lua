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
          },
          url = 'https://raw.githubusercontent.com/awslabs/goformation/master/schema/cloudformation.schema.json'
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
