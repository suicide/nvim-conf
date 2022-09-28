
require('lualine').setup()


vim.g.NERDTreeShowHidden = 1
vim.g.NERDTreeWinSize = 48
vim.g.NERDTreeShowLineNumbers= 1

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "nerdtree" },
  command = "setlocal relativenumber"
})
