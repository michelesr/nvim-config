local function tmux_wincmd_wrapper(key)
  local win = vim.api.nvim_get_current_win()
  vim.cmd('wincmd ' .. key)
  if vim.api.nvim_get_current_win() == win then
    local map = { h = 'L', k = 'D', j = 'U', l = 'R' }
    os.execute('tmux select-pane -' .. map[key])
  end
end

local opts = { remap = false, silent = true }
for _, key in ipairs({ 'h', 'k', 'j', 'l' }) do
  vim.keymap.set('n', '<C-w>' .. key, function()
    tmux_wincmd_wrapper(key)
  end, opts)
end
