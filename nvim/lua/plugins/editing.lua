-- SPDX-License-Identifier: Apache-2.0
-- Copyright 2026 thind
-- Basic but essential editing utilities.
return {
  -- Toggle comment: gcc (line), gc (selection)
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
  },
  -- Auto-close brackets/quotes, integrated with nvim-cmp
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({})
      local ok, cmp = pcall(require, "cmp")
      if ok then
        cmp.event:on("confirm_done", require("nvim-autopairs.completion.cmp").on_confirm_done())
      end
    end,
  },
}
