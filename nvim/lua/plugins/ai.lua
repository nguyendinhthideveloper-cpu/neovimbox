-- SPDX-License-Identifier: Apache-2.0
-- Copyright 2026 thind
-- AI: chat + Cursor-style inline edits, powered by Claude (Anthropic).
-- Reads ANTHROPIC_API_KEY from env -> no key means it stays silent (only errors on call).
-- Set ANTHROPIC_API_KEY in the shell before opening nvim (or export it / use nvx).
return {
  "olimorris/codecompanion.nvim",
  cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionActions" },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  keys = {
    { "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "v" }, desc = "AI: chat" },
    { "<leader>aa", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, desc = "AI: actions" },
    { "<leader>ai", ":CodeCompanion ", mode = { "n", "v" }, desc = "AI: inline (type request)" },
  },
  opts = {
    strategies = {
      chat = { adapter = "anthropic" },
      inline = { adapter = "anthropic" },
    },
  },
}
