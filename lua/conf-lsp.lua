require("nvim-lsp-installer").setup {}
local lspconfig = require("lspconfig")
local cmp_lsp = require('cmp_nvim_lsp')

local dap = require("dap")
local dapui = require("dapui")
local builtin = function() return require('telescope.builtin') end

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<Leader>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<Leader>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', '<Leader>F', vim.lsp.buf.formatting, bufopts)

  vim.keymap.set('n', '<Leader>cl', function ()
    return vim.lsp.codelens.run()
  end, bufopts)

  -- DO IT WITH TELESCOPE
  -- vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', 'gr', function()
    return builtin().lsp_references()
  end, bufopts)

  -- vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'gd', function()
    return builtin().lsp_definitions()
  end, bufopts)

  -- vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', 'gi', function()
    return builtin().lsp_implementations()
  end, bufopts)

  vim.keymap.set('n', 'gs', function()
    return builtin().lsp_dynamic_workspace_symbols()
    -- return builtin().lsp_workspace_symbols()
  end, bufopts)

  -- vim.keymap.set('n', '<Leader>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<Leader>D', function()
    return builtin().lsp_type_definitions()
  end, bufopts)

  -- vim.keymap.set('n', '<Leader>q', vim.diagnostic.setloclist, opts)
  vim.keymap.set('n', '<Leader>q', function()
    return builtin().diagnostics({
      bufnr = bufnr
    })
  end, opts)

  -- Set autocommands conditional on server_capabilities
  if client.server_capabilities.document_highlight then
    vim.api.nvim_exec([[
    augroup lsp_document_highlight
    autocmd! * <buffer>
    autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
    autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
    augroup END
    ]], false)
  end

  -- dap keymap
  vim.keymap.set('n', '<F5>', function()
    dap.continue()
  end, bufopts)
  vim.keymap.set('n', '<F6>', function()
    dap.step_over()
  end, bufopts)
  vim.keymap.set('n', '<F7>', function()
    dap.step_into()
  end, bufopts)
  vim.keymap.set('n', '<F8>', function()
    dap.step_out()
  end, bufopts)
  vim.keymap.set('n', '<Leader>db', function()
    dap.toggle_breakpoint()
  end, bufopts)
  vim.keymap.set('n', '<Leader>dB', function()
    dap.set_breakpoint(vim.fn.input('Breakpoint condition: '))
  end, bufopts)
  vim.keymap.set('n', '<Leader>dlp', function()
    dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))
  end, bufopts)
  vim.keymap.set('n', '<Leader>dr', function()
    dap.repl_open()
  end, bufopts)
  vim.keymap.set('n', '<Leader>dl', function()
    dap.run_last()
  end, bufopts)
end

local function config(_config)
  local capabilities = cmp_lsp.update_capabilities(
    vim.lsp.protocol.make_client_capabilities()
  )
  capabilities.textDocument.completion.completionItem.snippetSupport = true

  return vim.tbl_deep_extend("force", {
    -- capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities()),
    capabilities = capabilities,
    on_attach = on_attach,
  }, _config or {})
end

-- setup servers

lspconfig.tsserver.setup(config())

lspconfig.sumneko_lua.setup(config({
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = "LuaJIT",
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { "vim" },
      },
    },
  },
}))

lspconfig.rust_analyzer.setup(config())

-- scala metals
local metals = require("metals")
local metals_config = metals.bare_config()

-- Example of settings
metals_config.settings = {
  showImplicitArguments = true,
  excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
}

metals_config.on_attach = function(client, bufnr)
  metals.setup_dap()
  -- run default on_attach
  on_attach(client, bufnr)
end

-- Autocmd that will actually be in charging of starting the whole thing
local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "scala", "sbt"},
  callback = function()
    -- merge default and metals config here
    metals.initialize_or_attach(config(metals_config))
  end,
  group = nvim_metals_group,
})

-------------------------------------------------------------------------------
-- dap


dapui.setup()

-- run dapui when dap connects and so on
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

require("nvim-dap-virtual-text").setup()

-- dap scala metals
dap.configurations.scala = {
  {
    type = "scala",
    request = "launch",
    name = "RunOrTest",
    metals = {
      runType = "runOrTestFile",
      --args = { "firstArg", "secondArg", "thirdArg" }, -- here just as an example
    },
  },
  {
    type = "scala",
    request = "launch",
    name = "Test Target",
    metals = {
      runType = "testTarget",
    },
  },
}


dap.adapters.lldb = {
  type = 'executable',
  command = '/usr/bin/lldb-vscode', -- adjust as needed, must be absolute path
  name = 'lldb'
}

dap.configurations.cpp = {
  {
    name = 'Launch',
    type = 'lldb',
    request = 'launch',
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    args = {},

    -- 💀
    -- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
    --
    --    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
    --
    -- Otherwise you might get the following error:
    --
    --    Error on launch: Failed to attach to the target process
    --
    -- But you should be aware of the implications:
    -- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html
    -- runInTerminal = false,
  },
}

-- If you want to use this for Rust and C, add something like this:

dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp
