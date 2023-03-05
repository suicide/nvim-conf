-- diagnostics
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<Leader>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '{{', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', '}}', vim.diagnostic.goto_next, opts)
-- vim.keymap.set('n', '<Leader>q', vim.diagnostic.setloclist, opts)

-- delete
vim.keymap.set('n', 'x', '"_x', opts)
vim.keymap.set('n', 'd', '"_d', opts)
vim.keymap.set('v', 'd', '"_d', opts)
vim.keymap.set('n', 'D', '"_D', opts)

-- cut
vim.keymap.set('n', '<Leader>x', '"+d', opts)
vim.keymap.set('v', '<Leader>x', '"+d', opts)
vim.keymap.set('n', '<Leader>xx', '"+dd', opts)
vim.keymap.set('n', '<Leader>X', '"+D', opts)
