-- SPDX-License-Identifier: Apache-2.0
-- Copyright 2026 thind
-- Smart code folding (LSP + treesitter/indent fallback).
return {
  "kevinhwang91/nvim-ufo",
  dependencies = { "kevinhwang91/promise-async" },
  event = { "BufReadPost", "BufNewFile" },
  keys = {
    {
      "zR",
      function()
        require("ufo").openAllFolds()
      end,
      desc = "Open all folds",
    },
    {
      "zM",
      function()
        require("ufo").closeAllFolds()
      end,
      desc = "Close all folds",
    },
    {
      "zK",
      function()
        require("ufo").peekFoldedLinesUnderCursor()
      end,
      desc = "Peek fold contents",
    },
  },
  init = function()
    -- ufo needs these options to work. `foldcolumn` is the other one it needs,
    -- but it is gutter layout rather than fold behaviour so it lives with the
    -- rest of the gutter in config/options.lua.
    vim.o.foldlevel = 99
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true
  end,
  opts = {
    provider_selector = function()
      return { "treesitter", "indent" }
    end,
  },
}
