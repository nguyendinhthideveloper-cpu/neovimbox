-- SPDX-License-Identifier: Apache-2.0
-- Copyright 2026 thind
-- Integrated terminal: toggle with Ctrl-\ (including in terminal mode).
return {
  "akinsho/toggleterm.nvim",
  cmd = { "ToggleTerm", "TermExec" },
  keys = {
    { [[<C-\>]], "<cmd>ToggleTerm<cr>", mode = { "n", "t" }, desc = "Terminal (float)" },
    { "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", desc = "Terminal float" },
    { "<leader>th", "<cmd>ToggleTerm direction=horizontal<cr>", desc = "Terminal horizontal" },
  },
  opts = {
    open_mapping = [[<c-\>]],
    direction = "float",
    float_opts = { border = "rounded" },
  },
}
