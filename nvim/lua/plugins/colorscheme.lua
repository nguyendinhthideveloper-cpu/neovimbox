-- SPDX-License-Identifier: Apache-2.0
-- Copyright 2026 thind
return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000, -- load before other plugins to avoid a color flash
  config = function()
    require("catppuccin").setup({
      flavour = "mocha",
      integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        telescope = true,
        treesitter = true,
        mason = true,
        native_lsp = { enabled = true },
        -- New UI/extras:
        alpha = true,
        navic = { enabled = true },
        noice = true,
        notify = true,
        neogit = true,
        fidget = true,
        indent_blankline = { enabled = true },
        which_key = true,
        dap = true,
        dap_ui = true,
      },
    })
    vim.cmd.colorscheme("catppuccin")
  end,
}
