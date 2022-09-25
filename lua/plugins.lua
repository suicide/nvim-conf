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

  use {
    "williamboman/nvim-lsp-installer",
    "neovim/nvim-lspconfig",
  }

  use("mfussenegger/nvim-dap")
  use("rcarriga/nvim-dap-ui")
  use("theHamsta/nvim-dap-virtual-text")

  use("hrsh7th/cmp-nvim-lsp")
  use("hrsh7th/cmp-nvim-lsp-signature-help")
  use("hrsh7th/cmp-buffer")
  use("hrsh7th/cmp-path")
  use("hrsh7th/cmp-cmdline")
  use("hrsh7th/cmp-emoji")
  use("hrsh7th/cmp-calc")
  use("hrsh7th/nvim-cmp")

  use("L3MON4D3/LuaSnip")
  use("saadparwaiz1/cmp_luasnip")
end)
