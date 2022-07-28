M = {}
M.busy = false

local function activity_probe()
  local clients = vim.lsp.get_active_clients()
  for _, client in pairs(clients) do
    if next(client.requests) == nil then
      M.busy = false
    else
      M.busy = true
      return
    end
  end
end

local timer = vim.loop.new_timer()
timer:start(0, 1000, vim.schedule_wrap(activity_probe))

return M
