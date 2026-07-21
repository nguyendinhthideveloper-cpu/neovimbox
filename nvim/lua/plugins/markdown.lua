-- SPDX-License-Identifier: Apache-2.0
-- Copyright 2026 thind
-- Pretty Markdown RIGHT in the buffer (headings, code blocks, tables, checkboxes) —
-- suited to GUI-less containers (no need to open a browser like markdown-preview).
return {
  "MeanderingProgrammer/render-markdown.nvim",
  ft = { "markdown" },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  opts = {},
}
