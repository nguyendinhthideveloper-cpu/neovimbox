-- SPDX-License-Identifier: Apache-2.0
-- Copyright 2026 thind
-- Format code via conform.nvim (uses a dedicated formatter, falls back to LSP).
return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>cf",
      function()
        require("conform").format({ async = true, lsp_fallback = true })
      end,
      mode = { "n", "v" },
      desc = "Format file/selection",
    },
  },
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      python = { "isort", "black" },
      javascript = { "prettierd" },
      typescript = { "prettierd" },
      javascriptreact = { "prettierd" },
      typescriptreact = { "prettierd" },
      json = { "prettierd" },
      yaml = { "prettierd" },
      html = { "prettierd" },
      css = { "prettierd" },
      markdown = { "prettierd" },
      java = { "google-java-format" },
      go = { "goimports", "gofumpt" },
      rust = { "rustfmt" },
      c = { "clang_format" },
      cpp = { "clang_format" },
    },
    -- format on save; if there's no formatter for the ft, let the LSP handle it
    format_on_save = { timeout_ms = 3000, lsp_fallback = true },
  },
}
