-- SPDX-License-Identifier: Apache-2.0
-- Copyright 2026 thind
-- Cargo.toml: show the latest version, suggest versions, crate docs (virtual text).
return {
  "Saecki/crates.nvim",
  event = { "BufRead Cargo.toml" },
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {}, -- show versions via virtual text; don't enable the cmp source (deprecated)
}
