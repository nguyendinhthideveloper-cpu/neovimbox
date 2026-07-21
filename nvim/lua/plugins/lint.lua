-- SPDX-License-Identifier: Apache-2.0
-- Copyright 2026 thind
-- Lint via nvim-lint (complements the LSP diagnostics).
return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")
    lint.linters_by_ft = {
      python = { "ruff" },
      javascript = { "eslint_d" },
      typescript = { "eslint_d" },
      javascriptreact = { "eslint_d" },
      typescriptreact = { "eslint_d" },
      go = { "golangcilint" },
      -- Rust: clippy runs via rust_analyzer (checkOnSave) so it is not needed here
    }

    local group = vim.api.nvim_create_augroup("nvim-lint", { clear = true })
    vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
      group = group,
      callback = function()
        -- eslint_d only runs if the project has a config; ruff always works
        lint.try_lint()
      end,
    })
  end,
}
