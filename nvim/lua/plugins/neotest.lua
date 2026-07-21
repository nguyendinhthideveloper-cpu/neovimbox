-- SPDX-License-Identifier: Apache-2.0
-- Copyright 2026 thind
-- Run/debug tests right in the editor, showing pass/fail next to the code lines.
-- Adapters are only registered when their toolchain is present (adapts to the variant).
return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-neotest/neotest-go",
    "nvim-neotest/neotest-python",
  },
  keys = {
    {
      "<leader>tt",
      function()
        require("neotest").run.run()
      end,
      desc = "Test: nearest function",
    },
    {
      "<leader>tr",
      function()
        require("neotest").run.run(vim.fn.expand("%"))
      end,
      desc = "Test: whole file",
    },
    {
      "<leader>td",
      function()
        require("neotest").run.run({ strategy = "dap" })
      end,
      desc = "Test: debug nearest function",
    },
    {
      "<leader>ts",
      function()
        require("neotest").summary.toggle()
      end,
      desc = "Test: summary panel",
    },
    {
      "<leader>to",
      function()
        require("neotest").output.open({ enter = true })
      end,
      desc = "Test: view output",
    },
    {
      "<leader>tw",
      function()
        require("neotest").watch.toggle()
      end,
      desc = "Test: watch",
    },
  },
  config = function()
    local has = require("config.toolchains").has
    local adapters = {}
    if has("go") then
      table.insert(adapters, require("neotest-go"))
    end
    if has("python") then
      table.insert(adapters, require("neotest-python")({ dap = { justMyCode = false } }))
    end
    require("neotest").setup({ adapters = adapters })
  end,
}
