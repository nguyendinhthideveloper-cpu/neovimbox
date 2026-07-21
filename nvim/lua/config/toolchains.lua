-- SPDX-License-Identifier: Apache-2.0
-- Copyright 2026 thind
-- Helper to detect toolchains available on PATH.
-- This lets one Neovim config work across every image variant (base + <lang>):
-- LSP/formatter/linter only enable when the matching language is actually installed.
local M = {}

function M.has(exe)
  return vim.fn.executable(exe) == 1
end

return M
