-- SPDX-License-Identifier: Apache-2.0
-- Copyright 2026 thind
-- Visual commit graph (branch tree) inside Neovim, like the "Git Graph" panel in
-- an IDE. <leader>gl opens it; press <cr> on a commit to open its diff (diffview),
-- or select a range in visual mode to diff between two commits.
return {
  "isakbm/gitgraph.nvim",
  dependencies = { "sindrets/diffview.nvim" },
  keys = {
    {
      "<leader>gl",
      function()
        require("gitgraph").draw({}, { all = true, max_count = 5000 })
      end,
      desc = "Git graph (commit tree)",
    },
  },
  opts = {
    format = {
      timestamp = "%H:%M:%S %d-%m-%Y",
      fields = { "hash", "timestamp", "author", "branch_name", "tag" },
    },
    hooks = {
      -- <cr> on a commit -> show that commit's diff
      on_select_commit = function(commit)
        vim.cmd(":DiffviewOpen " .. commit.hash .. "^!")
      end,
      -- select a range (visual mode) -> diff between the two commits
      on_select_range_commit = function(from, to)
        vim.cmd(":DiffviewOpen " .. from.hash .. "~1.." .. to.hash)
      end,
    },
  },
}
