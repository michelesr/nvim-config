local lspconfig = require('lspconfig')

lspconfig['yamlls'].setup{
  settings = {
    yaml = {
      schemas = {
        ['kubernetes'] = 'foo.yaml'
      }
    }
  }
}
