-- SPDX-License-Identifier: Apache-2.0
-- Copyright 2026 thind
-- Buffer tab bar at the top (like VSCode's file tabs).
return {
  "akinsho/bufferline.nvim",
  event = "VeryLazy",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Previous buffer" },
    { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
    { "<leader>bd", "<cmd>bdelete<cr>", desc = "Close buffer" },
    { "<leader>bp", "<cmd>BufferLineTogglePin<cr>", desc = "Pin buffer" },
  },
  opts = {
    options = {
      diagnostics = "nvim_lsp",
      always_show_bufferline = false,
      offsets = {
        { filetype = "NvimTree", text = "Explorer", separator = true, text_align = "center" },
      },
    },
  },
}
