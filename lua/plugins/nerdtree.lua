return {

  {
    "preservim/nerdtree",
    dependencies = { "Xuyuanp/nerdtree-git-plugin" },
    lazy = false, -- start to use instead of netrw
    keys = {
      { "<C-t>", "<cmd>NERDTreeToggle<cr>", desc = "Toggle NERDTree" },
      { "<C-f>", "<cmd>NERDTreeFind<cr>",   desc = "Find File in NERDTree" },
    },
    config = function()
      vim.g.NERDTreeShowHidden = 1
      vim.g.NERDTreeWinSize = 48
      vim.g.NERDTreeShowLineNumbers = 1

      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "nerdtree" },
        command = "setlocal relativenumber"
      })
    end
  },
}
