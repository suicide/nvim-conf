return {
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'kyazdani42/nvim-web-devicons' },
    config = function()
      require("lualine").setup({
        sections = {
          lualine_x = {
            {
              require("lazy.status").updates,
              cond = require("lazy.status").has_updates,
              color = { fg = "#ff9e64" },
            },
            'encoding', 'fileformat', 'filetype'
          },
          lualine_c = {
            {
              'filename',
              path = 1,
            }
          },
        },
        inactive_sections = {
          lualine_c = {
            {
              'filename',
              path = 1,
            }
          }
        },
      })
    end
  }
}
