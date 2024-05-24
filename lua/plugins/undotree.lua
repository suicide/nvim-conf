return {
  {
    "mbbill/undotree",
    event = {"BufEnter"},
    keys = {
      {"<Leader>u", "<cmd>UndotreeToggle<cr>"},
    },
    config = function()
      vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
      vim.opt.undofile = true
    end
  }
}
