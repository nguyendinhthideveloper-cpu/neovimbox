-- SPDX-License-Identifier: Apache-2.0
-- Copyright 2026 thind
-- Project-wide find & replace through a buffer (uses ripgrep, already in base).
return {
  "MagicDuck/grug-far.nvim",
  cmd = "GrugFar",
  keys = {
    { "<leader>fR", "<cmd>GrugFar<cr>", desc = "Find & replace (grug-far)" },
  },
  opts = {},
}
