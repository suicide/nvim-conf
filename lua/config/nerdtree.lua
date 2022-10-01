vim.g.NERDTreeShowHidden = 1
vim.g.NERDTreeWinSize = 48
vim.g.NERDTreeShowLineNumbers= 1

vim.keymap.set('n', '<C-t>', ':NERDTreeToggle<CR>')
vim.keymap.set('n', '<C-f>', ':NERDTreeFind<CR>')

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "nerdtree" },
  command = "setlocal relativenumber"
})
