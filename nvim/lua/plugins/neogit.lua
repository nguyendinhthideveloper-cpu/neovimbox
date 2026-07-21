-- SPDX-License-Identifier: Apache-2.0
-- Copyright 2026 thind
-- Full Git in Neovim: stage/commit/branch/push/pull (complements gitsigns).
-- diffview for viewing diffs/history; telescope + plenary are already available.
return {
  "NeogitOrg/neogit",
  cmd = "Neogit",
  keys = {
    { "<leader>gg", "<cmd>Neogit<cr>", desc = "Neogit (git UI)" },
    { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diff view" },
    { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "File history" },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "sindrets/diffview.nvim",
    "nvim-telescope/telescope.nvim",
  },
  opts = {
    integrations = { telescope = true, diffview = true },
  },
}
