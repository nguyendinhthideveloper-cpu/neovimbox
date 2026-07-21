-- SPDX-License-Identifier: Apache-2.0
-- Copyright 2026 thind
-- Welcome screen shown when opening `nvim` without a file.
-- VimEnter fires even in headless mode -> guard: don't set up without a real UI
-- (avoids drawing the dashboard during build/smoke). The plugin is still preinstalled in the image.
return {
  "goolord/alpha-nvim",
  event = "VimEnter",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    if #vim.api.nvim_list_uis() == 0 then
      return -- headless: skip
    end
    local dashboard = require("alpha.themes.dashboard")
    dashboard.section.header.val = {
      "                                        ",
      "        neovimbox  ·  nvx                ",
      "   Java · Python · Node · Go · Rust · C++",
      "                                        ",
    }
    dashboard.section.buttons.val = {
      dashboard.button("f", "  Find file", "<cmd>Telescope find_files<cr>"),
      dashboard.button("r", "  Recent files", "<cmd>Telescope oldfiles<cr>"),
      dashboard.button("g", "  Grep contents", "<cmd>Telescope live_grep<cr>"),
      dashboard.button("e", "  New file", "<cmd>ene <BAR> startinsert<cr>"),
      dashboard.button("q", "  Quit", "<cmd>qa<cr>"),
    }
    require("alpha").setup(dashboard.config)
  end,
}
