local function get_file_name(path)
  local filename = string.match(path, '.*/([^/]+)$')
  return filename or path
end

local function get_buf_list()
  local buf_list = {}
  local curr_buf_numb = vim.api.nvim_get_current_buf()

  for _, buf_numb in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(buf_numb) and vim.bo[buf_numb].buflisted then
      local name = vim.api.nvim_buf_get_name(buf_numb) or "[unnamed]"
      if name ~= '' then
        table.insert(buf_list, {
          name = get_file_name(name),
          number = buf_numb,
          is_current = curr_buf_numb == buf_numb,
          is_modified = vim.api.nvim_buf_get_option(buf_numb, 'modified')
        })
      end
    end
  end

  return buf_list
end

BUFLINE_OFFSET = 1
local function get_bufline()
  local width = vim.opt.columns['_value'] - 12
  local line = ''
  local curr_start_index = -1
  local curr_end_index = -1
  local buffers = get_buf_list()

  for _, buf in ipairs(buffers) do
    local curr = buf.number .. ':' .. buf.name

    if buf.is_modified then
      curr = curr .. ' +'
    end

    if buf.is_current then
      curr = '[' .. curr .. ']'
      curr_start_index = string.len(line) + 1
      curr_end_index = curr_start_index + string.len(curr)
    end

    line = line .. ' ' .. curr
  end

  if string.len(line) <= width then
    return line
  end

  if curr_start_index < BUFLINE_OFFSET then
    BUFLINE_OFFSET = curr_start_index
  elseif curr_end_index > BUFLINE_OFFSET + width + 1 then
    BUFLINE_OFFSET = curr_end_index - width + 1
  end

  return string.sub(line, BUFLINE_OFFSET, BUFLINE_OFFSET + width - 1)
end

vim.api.nvim_create_augroup('Bufline', {})
vim.api.nvim_create_autocmd({ 'CursorHold', 'BufEnter', 'InsertLeave', 'VimResized' }, {
  group = 'Bufline',
  pattern = { '*' },
  callback = function()
    print(get_bufline())
  end
})

Keymap('n', '}', ':bnext<cr>', MapOpts)
Keymap('n', '{', ':bprev<cr>', MapOpts)

return {}
