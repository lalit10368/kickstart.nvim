local state = {
  floating = {
    buf = -1,
    win = -1,
  },
}

local function create_floating_window(opts)
  opts = opts or {}
  -- Get the current screen dimensions
  local width = opts.width or math.floor(vim.o.columns * 0.8)
  local height = opts.height or math.floor(vim.o.lines * 0.8)

  -- Calculate centered position
  local col = math.floor((vim.o.columns - width) / 2)
  local row = math.floor((vim.o.lines - height) / 2)

  -- Window configuration
  local win_config = {
    relative = 'editor',
    width = width,
    height = height,
    row = row,
    col = col,
    style = 'minimal',
    border = 'rounded',
  }

  -- Create the buffer and window
  local buf = nil
  if opts.buf == -1 or not vim.api.nvim_buf_is_valid(opts.buf) then
    buf = vim.api.nvim_create_buf(false, true) -- Create a scratch buffer
  else
    buf = opts.buf -- previous buffer
  end
  local win = vim.api.nvim_open_win(buf, true, win_config)
  return { buf = buf, win = win }
end

-- return {}

local function toggle_terminal()
  if not vim.api.nvim_win_is_valid(state.floating.win) then
    state.floating = create_floating_window { buf = state.floating.buf }
    if vim.bo[state.floating.buf].buftype ~= 'terminal' then
      vim.cmd.terminal()
    end
  else
    vim.api.nvim_win_hide(state.floating.win)
  end
end

return {
  vim.api.nvim_create_user_command('Floaterminal', toggle_terminal, {}),
  vim.keymap.set({ 'n', 't' }, '<space>tt', toggle_terminal),
}
