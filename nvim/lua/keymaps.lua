-- NerdTREE

vim.keymap.set('n', '<C-t>', ':NERDTreeToggle<CR>')
vim.keymap.set('n', '<C-f>', ':NERDTreeFind<CR>')

-- undo Tree
vim.keymap.set('n', '<Leader>u', ':UndotreeToggle<CR>')

-- diagnostics
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<Leader>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '{{', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', '}}', vim.diagnostic.goto_next, opts)
-- vim.keymap.set('n', '<Leader>q', vim.diagnostic.setloclist, opts)
