-- SPDX-License-Identifier: Apache-2.0
-- Copyright 2026 thind
-- Prettify the cmdline + notifications + LSP popups. Requires nui + notify.
-- event=VeryLazy does not fire when headless (build/smoke) -> not loaded then,
-- but the plugin is STILL pre-installed into the image (Lazy install does not depend on the event).
return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  },
  opts = {
    lsp = {
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
    },
    presets = {
      bottom_search = true,
      command_palette = true,
      long_message_to_split = true,
      lsp_doc_border = true,
    },
  },
}
