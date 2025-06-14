return {
  {
    {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      event = { "BufEnter" },
      config = function()
        -- Set compiler to get grammar installation working in NixOS. See
        -- https://github.com/nvim-treesitter/nvim-treesitter/issues/1449
        require('nvim-treesitter.install').compilers = { 'gcc' }
        require('nvim-treesitter.configs').setup {
          ensure_installed = "all",
          sync_install = false,
          ignore_install = {"ipkg"},

          highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
          },
        }
      end
    },

    {
      "nvim-treesitter/playground",
      dependencies = { 'nvim-treesitter' },
      -- lazy = true,
      -- cmd = {"TSPlayground"},
      event = { "BufEnter" },
    },
    {
      "nvim-treesitter/nvim-treesitter-context",
      dependencies = { 'nvim-treesitter' },
      event = { "BufEnter" },
      opts = {
        enabled = true,
        throttle = true
      }
    },
  }

}
