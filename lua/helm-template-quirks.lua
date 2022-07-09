local exports = {}

-- returns true if buffer contains a yaml template
local function is_helm_template()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  for _, line in pairs(lines) do
    if string.find(line, "{{") then
      return true
    end
  end
  return false
end

-- disable LSP and Treesitter syntax highlighting
local function disable_lsp_and_ts_higlight()
  vim.cmd('LspStop')
  vim.cmd('TSBufDisable highlight')
end

exports.run = function()
  if is_helm_template() then
    -- run with a 100ms delay to give time to LSP and TS to initialize
    vim.defer_fn(disable_lsp_and_ts_higlight, 100)
  end
end

return exports