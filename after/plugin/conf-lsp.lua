require("mason").setup {}
local lspconfig = require("lspconfig")
local util = require('lspconfig.util')
local cmp_lsp = require('cmp_nvim_lsp')
local null_ls = require('null-ls')

local dap = require("dap")
local dapui = require("dapui")
local builtin = function() return require('telescope.builtin') end

local env = {
  HOME = vim.loop.os_homedir(),
  XDG_CACHE_HOME = os.getenv 'XDG_CACHE_HOME',
  JDTLS_JVM_ARGS = os.getenv 'JDTLS_JVM_ARGS',
}

local mason_packages = env.HOME .. '/.local/share/nvim/mason/packages'

local cache_dir = env.XDG_CACHE_HOME and env.XDG_CACHE_HOME or util.path.join(env.HOME, '.cache')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_set_option_value('omnifunc', 'v:lua.vim.lsp.omnifunc', {buf = bufnr})

  -- null-ls messes up nvim formatting
  -- https://github.com/jose-elias-alvarez/null-ls.nvim/issues/1131
  vim.api.nvim_set_option_value('formatexpr', '', {buf = bufnr})

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', '<Leader>k', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<Leader>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<Leader>ca', vim.lsp.buf.code_action, bufopts)

  -- prefer null-ls for formatting
  local null_ls_sources = require('null-ls.sources')
  local ft = vim.bo[bufnr].filetype
  local has_null_ls = #null_ls_sources.get_available(ft, 'NULL_LS_FORMATTING') > 0
  local formatter_filter = function(cl)
      if has_null_ls then
        return cl.name == 'null-ls'
      else
        return true
      end
    end

  vim.keymap.set('n', '<Leader>F', function() vim.lsp.buf.format({ async = true, noremap = true, filter = formatter_filter }) end, bufopts)
  vim.keymap.set('v', '<Leader>F', function() vim.lsp.buf.format({ async = true, noremap = true, filter = formatter_filter }) end, bufopts)

  vim.keymap.set('n', '<Leader>cl', function()
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
  end, bufopts)

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
  local capabilities = cmp_lsp.default_capabilities()

  capabilities.textDocument.completion.completionItem.snippetSupport = true

  return vim.tbl_deep_extend("force", {
    capabilities = capabilities,
    on_attach = on_attach,
  }, _config or {})
end

-- setup servers

null_ls.setup({
  -- debug = true,
  sources = {
    null_ls.builtins.formatting.prettier.with({
      extra_filetypes = { "svelte", "astro" }
    }),
    null_ls.builtins.formatting.forge_fmt,
    -- null_ls.builtins.formatting.rustfmt,
    null_ls.builtins.formatting.scalafmt,
    null_ls.builtins.diagnostics.codespell,
    null_ls.builtins.diagnostics.eslint.with({
      extra_filetypes = { "svelte", "astro" }
    }),
    -- check https://github.com/jose-elias-alvarez/null-ls.nvim/pull/811
    -- as soon as there is an error the output is written to stderr instead stdout
    -- null_ls.builtins.diagnostics.solhint,
  }
})

lspconfig.ltex.setup(config({
  settings = {
    ltex = {
      language = "en-US",
    }
  }
}))

lspconfig.tsserver.setup(config({
  on_attach = function (client, bufnr)
    -- use null-ls instead
    client.server_capabilities.document_formatting = false
    on_attach(client, bufnr)
  end
}))

lspconfig.lua_ls.setup(config({
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
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
}))

lspconfig.rust_analyzer.setup(config())

lspconfig.bashls.setup(config())
lspconfig.jsonls.setup(config())
lspconfig.html.setup(config())
lspconfig.cssls.setup(config())
lspconfig.tailwindcss.setup(config())
lspconfig.svelte.setup(config())
lspconfig.marksman.setup(config())
lspconfig.dockerls.setup(config())
lspconfig.gopls.setup(config())
-- lspconfig.solc.setup(config())
-- use solidity while solc is still having problems, needs solidity-ls and solc
lspconfig.solidity.setup(config())

lspconfig.yamlls.setup(config({
  settings = {
    yaml = {
      schemas = {
      }
    }
  }
}))

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
  pattern = { "scala", "sbt" },
  callback = function()
    -- merge default and metals config here
    metals.initialize_or_attach(config(metals_config))
  end,
  group = nvim_metals_group,
})

-- Java jdtls

local jdtls = require('jdtls')

local create_jdtls_config = function()
  local root_markers = { '.git', 'mvnw', 'gradlew' }
  local root_dir = require('jdtls.setup').find_root(root_markers)
  local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
  local jdtls_cache_dir = util.path.join(cache_dir, 'jdtls', project_name)
  local config_dir = util.path.join(jdtls_cache_dir, 'config')
  local workspace_dir = util.path.join(jdtls_cache_dir, 'workspace')

  local bundles = {
    vim.fn.glob(mason_packages ..
      "/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar"),
  }
  -- TODO fix this
  -- vim.list_extend(bundles, vim.split(vim.fn.glob(mason_packages .. "/java-test/extension/server/*.jar")))

  local function get_jdtls_jvm_args()
    local args = {}
    for a in string.gmatch((env.JDTLS_JVM_ARGS or ''), '%S+') do
      local arg = string.format('--jvm-arg=%s', a)
      table.insert(args, arg)
    end
    return unpack(args)
  end

  local jdtls_config = {
    -- The command that starts the language server
    -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
    cmd_env = {
      JAVA_HOME = "/usr/lib/jvm/java-17-openjdk",
    },
    cmd = {
      -- 💀
      'jdtls', -- or '/path/to/java17_or_newer/bin/java'
      -- depends on if `java` is in your $PATH env variable and if it points to the right version.
      '-configuration', config_dir,
      '-data', workspace_dir,
      get_jdtls_jvm_args()
    },

    -- 💀
    -- This is the default if not provided, you can remove it. Or adjust as needed.
    -- One dedicated LSP server & client will be started per unique root_dir
    root_dir = require('jdtls.setup').find_root(root_markers),

    -- Here you can configure eclipse.jdt.ls specific settings
    -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
    -- for a list of options
    settings = {
      java = {
        signatureHelp = { enabled = true },
        contentProvider = { preferred = 'fernflower' },
        completion = {
          favoriteStaticMembers = {
            "org.hamcrest.MatcherAssert.assertThat",
            "org.hamcrest.Matchers.*",
            "org.hamcrest.CoreMatchers.*",
            "org.junit.jupiter.api.Assertions.*",
            "java.util.Objects.requireNonNull",
            "java.util.Objects.requireNonNullElse",
            "org.mockito.Mockito.*"
          },
          filteredTypes = {
            "com.sun.*",
            "io.micrometer.shaded.*",
            "java.awt.*",
            "jdk.*",
            "sun.*",
          },
        },
        sources = {
          organizeImports = {
            starThreshold = 9999;
            staticStarThreshold = 9999;
          }
        },
        codeGeneration = {
          toString = {
            template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}"
          },
          hashCodeEquals = {
            useJava7Objects = true,
          },
          useBlocks = true,
        },
        configuration = {
          runtimes = {
            {
              name = "JavaSE-1.8",
              path = "/usr/lib/jvm/java-8-openjdk/",
            },
            {
              name = "JavaSE-11",
              path = "/usr/lib/jvm/java-11-openjdk/",
              default = true,
            },
            {
              name = "JavaSE-17",
              path = "/usr/lib/jvm/java-17-openjdk/",
            },
            {
              name = "JavaSE-21",
              path = "/usr/lib/jvm/java-21-openjdk/",
            },
          }
        }
      }
    },

    -- Language server `initializationOptions`
    -- You need to extend the `bundles` with paths to jar files
    -- if you want to use additional eclipse.jdt.ls plugins.
    --
    -- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
    --
    -- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
    init_options = {
      bundles = bundles
    },
    on_attach = function(client, bufnr)
      on_attach(client, bufnr)

      local jdtls_setup = require('jdtls.setup')
      jdtls_setup.add_commands()
      jdtls.setup_dap({ hotcodereplace = 'auto' })

    end
  }

  return jdtls_config

end

-- Autocmd that will actually be in charging of starting the whole thing
local nvim_jdtls_group = vim.api.nvim_create_augroup("nvim-jdtls", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "java" },
  callback = function()
    -- merge default and jdtls config here
    jdtls.start_or_attach(config(create_jdtls_config()))
  end,
  group = nvim_jdtls_group,
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

dap.configurations.java = {
  {
    type = 'java';
    request = 'attach';
    name = "Debug (Attach) - Remote";
    hostName = "127.0.0.1";
    port = 5005;
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
