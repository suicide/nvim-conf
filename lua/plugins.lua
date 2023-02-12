return require("packer").startup(function(use)
  use("wbthomason/packer.nvim")

  use {
    { "preservim/nerdtree",
      config = [[require('config.nerdtree')]],
    },
    { "Xuyuanp/nerdtree-git-plugin",
      after = 'nerdtree',
    },
  }

  -- Themes
  use {
    { "gruvbox-community/gruvbox" },
    { "folke/tokyonight.nvim" },
  }

  use {
    'nvim-lualine/lualine.nvim',
    config = [[require('config.lualine')]],
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }

  use {
    "mbbill/undotree",
    config = [[require('config.undotree')]],
  }

  -- Telescope
  use {
    {
      'nvim-telescope/telescope.nvim', branch = '0.1.x',
      requires = {
        'nvim-lua/plenary.nvim',
        'nvim-telescope/telescope-fzf-native.nvim'
      },
      config = [[require('config.telescope')]],
    },
    { 'nvim-telescope/telescope-fzf-native.nvim',
      run = 'make',
    },
  }

  use {
    'lewis6991/gitsigns.nvim',
    requires = 'nvim-lua/plenary.nvim',
    config = [[require('config.gitsigns')]],
  }

  -- Treesitter
  use {
    { "nvim-treesitter/nvim-treesitter",
      run = ":TSUpdate",
      config = [[require('config.treesitter')]],
    },

    { "nvim-treesitter/playground",
      after = 'nvim-treesitter',
    },
    { "nvim-treesitter/nvim-treesitter-context",
      config = [[require('config.treesitter-context')]],
      after = 'nvim-treesitter',
    },
  }

  -- LSP
  use {
    { "neovim/nvim-lspconfig" },
    { "williamboman/mason.nvim" },
    { "scalameta/nvim-metals" },
    { "mfussenegger/nvim-jdtls" },
    { "jose-elias-alvarez/null-ls.nvim" },
  }

  -- DAP
  use {
    { "mfussenegger/nvim-dap" },
    { "rcarriga/nvim-dap-ui" },
    { "theHamsta/nvim-dap-virtual-text" },
  }

  -- CMP
  use {
    "hrsh7th/nvim-cmp",
    requires = {
      { "hrsh7th/cmp-nvim-lsp", after = 'nvim-cmp' },
      { "hrsh7th/cmp-nvim-lsp-signature-help", after = 'nvim-cmp' },
      { "hrsh7th/cmp-buffer", after = 'nvim-cmp' },
      { "hrsh7th/cmp-path", after = 'nvim-cmp' },
      { "hrsh7th/cmp-cmdline", after = 'nvim-cmp' },
      { "hrsh7th/cmp-emoji", after = 'nvim-cmp' },
      { "hrsh7th/cmp-calc", after = 'nvim-cmp' },
      { "f3fora/cmp-spell", after = 'nvim-cmp' },
      { "saadparwaiz1/cmp_luasnip", after = { 'nvim-cmp', 'LuaSnip' } },
    },
    config = [[require('config.cmp')]],
  }

  use {
    {
      "L3MON4D3/LuaSnip",
      config = [[require('config.luasnip')]],
    },
    { 'rafamadriz/friendly-snippets' }
  }

  use {
    "numToStr/Comment.nvim",
    config = [[require('config.comment')]]
  }

  use {
    "windwp/nvim-autopairs",
    config = function() require("nvim-autopairs").setup {} end
  }
end)
