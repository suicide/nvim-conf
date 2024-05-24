return {
  -- LSP
  {
    {"neovim/nvim-lspconfig", lazy = true},
    {"williamboman/mason.nvim", lazy = true},
    {"scalameta/nvim-metals", lazy = true},
    {"mfussenegger/nvim-jdtls", lazy = true},
    {"nvimtools/none-ls.nvim", lazy = true},
  },

  -- DAP
  {
    {"mfussenegger/nvim-dap", lazy = true},
    { "rcarriga/nvim-dap-ui", dependencies = { "nvim-neotest/nvim-nio" }, lazy = true },
    {"theHamsta/nvim-dap-virtual-text", lazy = true},
  }
}
