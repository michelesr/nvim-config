M = {}

---@param bufnr integer
---@param new_schema string
function M.set_yaml_schema(bufnr, new_schema)
  local bufuri = vim.uri_from_bufnr(bufnr)
  local client = vim.lsp.get_clients({ bufnr = bufnr })[1]
  local settings = client.settings

  -- make lua_ls happy and ensure schemas is initialized
  settings.yaml['schemas'] = settings.yaml['schemas'] or {}

  -- we don't want more than 1 schema per file
  for key, schema in pairs(settings.yaml.schemas) do
    if schema == bufuri then
      settings.yaml.schemas[key] = nil
    elseif type(schema) == 'table' and vim.tbl_contains(settings.yaml.schemas[key], bufuri) then
      settings.yaml.schemas[key] = vim.tbl_filter(function(e)
        return e ~= bufuri
      end, schema)
    end
  end

  local t = type(settings.yaml.schemas[new_schema])
  if t == 'table' then
    table.insert(settings.yaml.schemas[new_schema], bufuri)
  elseif t == 'string' then
    settings.yaml.schemas[new_schema] = { settings.yaml.schemas[new_schema], bufuri }
  else
    settings.yaml.schemas[new_schema] = bufuri
  end

  client:notify('workspace/didChangeConfiguration', {
    settings = client.settings,
  })
end

function M.yaml_on_attach()
  vim.api.nvim_create_user_command('YamlSchema', function(args)
    M.set_yaml_schema(0, args.args)
  end, { nargs = 1 })
end
return M
