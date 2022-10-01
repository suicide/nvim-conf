-- diagnostics
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<Leader>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '{{', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', '}}', vim.diagnostic.goto_next, opts)
-- vim.keymap.set('n', '<Leader>q', vim.diagnostic.setloclist, opts)
