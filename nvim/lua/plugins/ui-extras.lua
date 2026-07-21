-- SPDX-License-Identifier: Apache-2.0
-- Copyright 2026 thind
-- Small UI utilities: indent guides + LSP progress spinner.
return {
  -- Indent guides.
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      indent = { char = "│" },
      scope = { enabled = true, show_start = false, show_end = false },
    },
  },
  -- Corner-of-screen spinner while the LSP is indexing/loading.
  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    opts = {},
  },
}
