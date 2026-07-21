-- SPDX-License-Identifier: Apache-2.0
-- Copyright 2026 thind
return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  event = "VeryLazy",
  config = function()
    require("lualine").setup({
      options = {
        theme = "catppuccin",
        globalstatus = true,
        section_separators = "",
        component_separators = "",
      },
    })
  end,
}
