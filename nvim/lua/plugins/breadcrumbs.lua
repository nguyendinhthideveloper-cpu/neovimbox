-- SPDX-License-Identifier: Apache-2.0
-- Copyright 2026 thind
-- Breadcrumbs (winbar): "file > Class > method" at the top of the window.
-- navic gets symbol positions from the LSP; barbecue renders them on the winbar.
-- navic is attached manually in LspAttach (lsp.lua) -> attach_navic = false.
return {
  "utilyre/barbecue.nvim",
  event = { "BufReadPost", "BufNewFile" },
  dependencies = {
    "SmiteshP/nvim-navic",
    "nvim-tree/nvim-web-devicons",
  },
  opts = {
    attach_navic = false,
    create_autocmd = true,
    show_modified = true,
  },
}
