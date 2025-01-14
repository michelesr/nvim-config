-- map wincmd keys to tmux-select pane directions
local map = { h = 'L', k = 'D', j = 'U', l = 'R' }

local function tmux_wincmd_wrapper(key)
  local win = vim.api.nvim_get_current_win()
  vim.cmd('wincmd ' .. key)
  -- if vim window hasn't changed
  if vim.api.nvim_get_current_win() == win then
    -- ask tmux to change pane instead
    os.execute('tmux select-pane -' .. map[key])
  end
end

for key, _ in pairs(map) do
  vim.keymap.set('n', '<C-w>' .. key, function()
    tmux_wincmd_wrapper(key)
  end)
end
