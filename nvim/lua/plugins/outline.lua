-- SPDX-License-Identifier: Apache-2.0
-- Copyright 2026 thind
-- Outline: a panel listing a file's symbols (functions/classes/variables). <leader>o to toggle.
-- Uses outline.nvim (supports nvim 0.7+); the newer aerial requires nvim 0.12+.
return {
  "hedyhli/outline.nvim",
  cmd = { "Outline", "OutlineOpen" },
  keys = {
    { "<leader>o", "<cmd>Outline<cr>", desc = "Outline (symbols)" },
  },
  opts = {
    outline_window = { position = "right", width = 30 },
  },
}
