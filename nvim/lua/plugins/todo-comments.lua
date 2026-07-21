-- SPDX-License-Identifier: Apache-2.0
-- Copyright 2026 thind
-- Highlight + search TODO / FIXME / HACK / NOTE / WARN.
return {
  "folke/todo-comments.nvim",
  event = { "BufReadPost", "BufNewFile" },
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    {
      "]t",
      function()
        require("todo-comments").jump_next()
      end,
      desc = "Next TODO",
    },
    {
      "[t",
      function()
        require("todo-comments").jump_prev()
      end,
      desc = "Previous TODO",
    },
    { "<leader>ft", "<cmd>TodoTelescope<cr>", desc = "Find TODO (Telescope)" },
    { "<leader>xt", "<cmd>Trouble todo toggle<cr>", desc = "TODO (Trouble)" },
  },
  opts = {},
}
