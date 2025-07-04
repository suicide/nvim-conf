local js_like_formatters = { "prettierd", "prettier", stop_after_first = true };

return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      -- Customize or remove this keymap to your liking
      "<leader>F",
      function()
        require("conform").format({ async = true })
      end,
      mode = "",
      desc = "Format buffer",
    },
  },
  -- This will provide type hinting with LuaLS
  ---@module "conform"
  ---@type conform.setupOpts
  opts = {
    -- Define your formatters
    formatters_by_ft = {
      lua = { "stylua" },
      python = { "isort", "black" },
      javascript = js_like_formatters,
      typescript = js_like_formatters,
      json = js_like_formatters,
      jsonc = js_like_formatters,
      html = js_like_formatters,
      svelte = js_like_formatters,
      astro = js_like_formatters,
      solidity = { "forge_fmt" },
      tex = { "tex-fmt" },
      nix = { "alejandra" },
      markdown = js_like_formatters,
    },
    -- Set default options
    default_format_opts = {
      lsp_format = "fallback",
    },
    -- Set up format-on-save
    -- format_on_save = { timeout_ms = 500 },
    -- Customize formatters
    formatters = {
      -- shfmt = {
      --   prepend_args = { "-i", "2" },
      -- },
    },
  },
  init = function()
    -- If you want the formatexpr, here is the place to set it
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  end,
}
