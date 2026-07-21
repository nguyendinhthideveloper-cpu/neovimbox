-- SPDX-License-Identifier: Apache-2.0
-- Copyright 2026 thind
-- Keybinding hints: press <leader> and wait, a popup shows the command groups.
return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    spec = {
      { "<leader>f", group = "find / format" },
      { "<leader>h", group = "git hunk" },
      { "<leader>c", group = "code" },
      { "<leader>d", group = "debug" },
      { "<leader>r", group = "rename" },
      { "<leader>b", group = "buffer" },
      { "<leader>t", group = "terminal / test" },
      { "<leader>g", group = "git (neogit/diff/graph)" },
      { "<leader>x", group = "diagnostics (trouble)" },
      { "<leader>s", group = "session" },
      { "<leader>m", group = "harpoon (marks)" },
      { "<leader>a", group = "AI (codecompanion)" },
      { "<leader>o", desc = "outline" },
      { "<leader>?", desc = "help (nvx cheatsheet)" },
    },
  },
}
