-- LSP server settings
--
-- you should bookmark this file, e.g. mS
-- and then jump to it with `S or 'S
--
-- use :LspConfigReload to reload config after making changes

local lspconfig = require('lspconfig')

lspconfig['jsonls'].setup {
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

lspconfig['yamlls'].setup {
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
}

-- This strips out &nbsp; and some ending escaped backslashes out of hover
-- strings because the pyright LSP is... odd with how it creates hover strings.
local function hover(_, result, ctx, config)
  if not result then -- noop
  elseif type(result.contents) == 'string' then
    local s = string.gsub(result.contents, '&nbsp;', ' ')
    s = string.gsub(s, '\\\n', '\n')
    result.contents = s
  elseif type(result.contents) == 'table' then
    local s = string.gsub(result.contents.value or '', '&nbsp;', ' ')
    s = string.gsub(s, '\\\n', '\n')
    result.contents.value = s
  end
  return vim.lsp.handlers.hover(_, result, ctx, config)
end

lspconfig['pyright'].setup {
  handlers = {
    ['textDocument/hover'] = vim.lsp.with(hover, {}),
  },
}
