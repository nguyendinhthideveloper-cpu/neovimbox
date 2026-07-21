-- SPDX-License-Identifier: Apache-2.0
-- Copyright 2026 thind
return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make", -- needs build-essential (already in the image)
    },
  },
  keys = {
    { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find file" },
    { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Grep contents (needs ripgrep)" },
    { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffer list" },
    { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help" },
    { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent files" },
  },
  config = function()
    local telescope = require("telescope")
    telescope.setup({
      defaults = {
        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
        },
      },
    })
    pcall(telescope.load_extension, "fzf")
  end,
}
