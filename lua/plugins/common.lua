vim.opt.backup = false
vim.opt.clipboard = 'unnamedplus'
vim.opt.ignorecase = true
vim.opt.expandtab = true
vim.opt.cursorline = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.numberwidth = 4
vim.opt.signcolumn = 'yes'
vim.opt.scrolloff = 4
vim.opt.sidescrolloff = 2
vim.opt.laststatus = 3
vim.opt.updatetime = 1000
vim.opt.timeoutlen = 750
vim.opt.termguicolors = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.wrap = true
vim.opt.breakindent = true
vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.opt.foldmethod = 'expr'
vim.opt.foldenable = false
vim.opt.splitright = true
vim.opt.splitbelow = true

Keymap('n', 'c', '"_c', MapOpts)
Keymap('n', 'C', '"_C', MapOpts)
Keymap('n', 'd', '"_d', MapOpts)
Keymap('n', 'D', '"_D', MapOpts)
Keymap('n', 'dd', '"_dd', MapOpts)
Keymap('v', 'd', '"_d', MapOpts)
Keymap('v', 'p', '"_dP', MapOpts)

Keymap('n', '<c-h>', '<c-w>h', MapOpts)
Keymap('n', '<c-j>', '<c-w>j', MapOpts)
Keymap('n', '<c-k>', '<c-w>k', MapOpts)
Keymap('n', '<c-l>', '<c-w>l', MapOpts)

Keymap('n', '<c-up>', ':resize +2<cr>', MapOpts)
Keymap('n', '<c-down>', ':resize -2<cr>', MapOpts)
Keymap('n', '<c-left>', ':vertical resize -2<cr>', MapOpts)
Keymap('n', '<c-right>', ':vertical resize +2<cr>', MapOpts)

Keymap('n', '<esc>', ':noh<cr>', MapOpts)

Keymap('n', '<', '<gv', MapOpts)
Keymap('n', '>', '>gv', MapOpts)
Keymap('v', '<', '<gv', MapOpts)
Keymap('v', '>', '>gv', MapOpts)

Keymap('n', '<a-j>', ':m .+1<cr>==', MapOpts)
Keymap('n', '<a-k>', ':m .-2<cr>==', MapOpts)
Keymap('v', '<a-j>', ':m .+1<cr>==', MapOpts)
Keymap('v', '<a-k>', ':m .-2<cr>==', MapOpts)
Keymap('x', '<a-j>', ":move '>+1<cr>gv-gv", MapOpts)
Keymap('x', '<a-k>', ":move '<-2<cr>gv-gv", MapOpts)

vim.cmd [[
augroup highlight_yank
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank({ higroup='IncSearch', timeout=200 })
augroup END
]]

return {}
