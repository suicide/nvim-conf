return require("packer").startup(function()
  use("wbthomason/packer.nvim")

  use("preservim/nerdtree")
  use("Xuyuanp/nerdtree-git-plugin")

  use("gruvbox-community/gruvbox")

  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }

  use("mbbill/undotree")

  use {
    'nvim-telescope/telescope.nvim', branch = '0.1.x',
    requires = { { 'nvim-lua/plenary.nvim' } }
  }
  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }

  use { 'lewis6991/gitsigns.nvim' }

  use("nvim-treesitter/nvim-treesitter", {
    run = ":TSUpdate"
  })

  use("nvim-treesitter/playground")
  use("nvim-treesitter/nvim-treesitter-context")
end)

-- TODO LSP stuff
