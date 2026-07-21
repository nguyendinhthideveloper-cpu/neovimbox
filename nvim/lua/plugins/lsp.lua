-- SPDX-License-Identifier: Apache-2.0
-- Copyright 2026 thind
return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "williamboman/mason.nvim", -- configured in lua/plugins/mason.lua
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/cmp-nvim-lsp",
    "b0o/schemastore.nvim", -- JSON/YAML schemas (k8s, github workflow, package.json...)
  },
  config = function()
    local has = require("config.toolchains").has

    -- Keymaps bound when the LSP attaches to a buffer
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(ev)
        local function map(keys, fn, desc)
          vim.keymap.set("n", keys, fn, { buffer = ev.buf, desc = "LSP: " .. desc })
        end
        map("gd", vim.lsp.buf.definition, "Go to definition")
        map("gr", vim.lsp.buf.references, "References")
        map("gI", vim.lsp.buf.implementation, "Implementation")
        map("K", vim.lsp.buf.hover, "Hover doc")
        map("<leader>rn", vim.lsp.buf.rename, "Rename")
        map("<leader>ca", vim.lsp.buf.code_action, "Code action")
        map("<leader>f", function()
          vim.lsp.buf.format({ async = true })
        end, "Format")
        map("[d", vim.diagnostic.goto_prev, "Previous diagnostic")
        map("]d", vim.diagnostic.goto_next, "Next diagnostic")

        -- Attach navic (data source for breadcrumbs) if the server supports documentSymbol.
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if
          client
          and client.server_capabilities
          and client.server_capabilities.documentSymbolProvider
        then
          local ok, navic = pcall(require, "nvim-navic")
          if ok then
            navic.attach(client, ev.buf)
          end
        end
      end,
    })

    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    -- Only enable a server when its toolchain is present (adapts to the image variant).
    -- jdtls is handled separately in ftplugin/java.lua; rust_analyzer + clangd come from rustup/apt.
    local servers = {
      lua_ls = {
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
          },
        },
      },
    }
    if has("node") then
      servers.ts_ls = {}
    end
    if has("python") and has("node") then
      servers.pyright = {} -- pyright is a node app, needs both python and node
    end
    if has("go") then
      servers.gopls = {
        settings = {
          gopls = {
            analyses = { unusedparams = true, nilness = true },
            staticcheck = true,
            gofumpt = true,
          },
        },
      }
    end
    if has("rust-analyzer") or has("cargo") then
      servers.rust_analyzer = {
        settings = {
          ["rust-analyzer"] = {
            -- newer rust-analyzer: checkOnSave is a boolean, the command lives in check.command
            -- (the old schema `checkOnSave = { command = ... }` caused an "invalid type: map" error).
            checkOnSave = true,
            check = { command = "clippy" },
            cargo = { allFeatures = true },
          },
        },
      }
    end
    if has("clangd") then
      servers.clangd = {}
    end

    -- Infrastructure LSPs (run on node in the base -> available in EVERY variant): shell, YAML,
    -- JSON, Dockerfile, TOML. Great when editing CI/k8s/Docker/config.
    local ok_ss, schemastore = pcall(require, "schemastore")
    servers.bashls = {}
    servers.dockerls = {}
    servers.taplo = {}
    servers.jsonls = {
      settings = {
        json = {
          schemas = ok_ss and schemastore.json.schemas() or nil,
          validate = { enable = true },
        },
      },
    }
    servers.yamlls = {
      settings = {
        yaml = {
          schemaStore = { enable = false, url = "" }, -- use SchemaStore.nvim instead of the built-in version
          schemas = ok_ss and schemastore.yaml.schemas() or nil,
        },
      },
    }

    -- Only ask mason to install servers that (a) are in the list above and (b) are mason-managed.
    -- rust_analyzer (rustup) and clangd (apt) do not need mason.
    local mason_managed = {
      lua_ls = true,
      ts_ls = true,
      pyright = true,
      gopls = true,
      bashls = true,
      yamlls = true,
      jsonls = true,
      dockerls = true,
      taplo = true,
    }
    local ensure = {}
    for name, _ in pairs(servers) do
      if mason_managed[name] then
        table.insert(ensure, name)
      end
    end

    require("mason-lspconfig").setup({
      ensure_installed = ensure,
      automatic_installation = true,
      automatic_enable = false, -- avoid double-setup with the manual loop below
    })

    local lspconfig = require("lspconfig")
    for name, cfg in pairs(servers) do
      cfg.capabilities = capabilities
      lspconfig[name].setup(cfg)
    end
  end,
}
