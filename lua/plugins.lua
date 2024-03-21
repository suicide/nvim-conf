return require("packer").startup(function(use)
  use("wbthomason/packer.nvim")


  -- Treesitter
  use {
    { "nvim-treesitter/nvim-treesitter",
      run = ":TSUpdate",
      config = [[require('config.treesitter')]],
    },
  }

end)
