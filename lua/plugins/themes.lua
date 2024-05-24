return {
  {
    -- { "gruvbox-community/gruvbox" },
    {
      "folke/tokyonight.nvim",
      lazy = false,
      priority = 1000,
      config = function()
        -- load the colorscheme here
        vim.cmd([[syntax on]])

        vim.cmd([[highlight ColorColumn ctermbg=0 guibg=lightgrey]])
        vim.cmd([[hi LspReferenceText cterm=bold gui=bold]])
        vim.cmd([[hi LspReferenceRead cterm=bold gui=bold]])
        vim.cmd([[hi LspReferenceWrite cterm=bold gui=bold]])

        -- vim.cmd([[colorscheme gruvbox]])
        vim.cmd([[colorscheme tokyonight-night]])

        -- vim.cmd([[set background=dark]])
        -- vim.opt.background = "dark"
      end,
    },
  }
}
