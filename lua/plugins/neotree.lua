return {
  {
    's1n7ax/nvim-window-picker',
    version = '2.*',
    lazy = false,
    opts = {
      filter_rules = {
        include_current_win = false,
        autoselect_one = true,
        -- filter using buffer options
        bo = {
          -- if the file type is one of following, the window will be ignored
          filetype = { 'neo-tree', "neo-tree-popup", "notify" },
          -- if the buffer type is one of following, the window will be ignored
          buftype = { 'terminal', "quickfix" },
        },
      },
    }
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
      -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
      's1n7ax/nvim-window-picker',
    },
    lazy = false,
    keys = {
      { "<C-t>", "<cmd>Neotree toggle<cr>", desc = "Toggle Neotree" },
      { "<C-f>", "<cmd>Neotree reveal<cr>", desc = "Find in Neotree" },
    },
    opts = {
      filesystem = {
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_hidden = false,
        },
        hijack_netrw_behavior = "open_current",
      }
    }
  }
}
