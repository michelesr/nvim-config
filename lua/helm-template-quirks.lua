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

-- disable LSP diagnostic and Treesitter syntax highlighting
local function disable_lsp_and_ts_higlight()
  vim.diagnostic.disable(0)
  vim.cmd('TSBufDisable highlight')
end

local M = {}
function M.run()
  if is_helm_template() then
    -- defer so that LSP and TS can be initialized properly
    vim.defer_fn(disable_lsp_and_ts_higlight, 1)
  end
end

return M
