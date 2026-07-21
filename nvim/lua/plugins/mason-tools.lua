-- SPDX-License-Identifier: Apache-2.0
-- Copyright 2026 thind
-- Automatically install formatters / linters / DAP adapters via mason — only the tools
-- whose toolchain is present, so a single config runs across every image variant.
return {
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  dependencies = { "williamboman/mason.nvim" },
  event = "VeryLazy",
  opts = function()
    local has = require("config.toolchains").has
    local tools = {
      -- always present (editor-agnostic, based on node in the base)
      "stylua",
      "prettierd",
      "eslint_d",
    }
    local function add(list)
      vim.list_extend(tools, list)
    end

    if has("python") then
      add({ "black", "isort", "ruff", "debugpy" })
    end
    if has("go") then
      add({ "gofumpt", "goimports", "golangci-lint", "delve" })
    end
    if has("java") then
      add({ "jdtls", "java-debug-adapter", "java-test", "google-java-format" })
    end
    if has("cargo") or has("clangd") then
      add({ "codelldb" }) -- Rust / C / C++
    end

    return { ensure_installed = tools, run_on_start = true }
  end,
}
