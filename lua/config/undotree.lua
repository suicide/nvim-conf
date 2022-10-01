vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- undo Tree
vim.keymap.set('n', '<Leader>u', ':UndotreeToggle<CR>')

