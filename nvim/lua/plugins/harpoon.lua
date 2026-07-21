-- SPDX-License-Identifier: Apache-2.0
-- Copyright 2026 thind
-- Harpoon: pin a few frequently used files and jump to them instantly (<leader>m1..m4).
return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = function()
    local keys = {
      {
        "<leader>ma",
        function()
          require("harpoon"):list():add()
        end,
        desc = "Harpoon: pin file",
      },
      {
        "<C-e>",
        function()
          local h = require("harpoon")
          h.ui:toggle_quick_menu(h:list())
        end,
        desc = "Harpoon: menu",
      },
    }
    for i = 1, 4 do
      table.insert(keys, {
        "<leader>m" .. i,
        function()
          require("harpoon"):list():select(i)
        end,
        desc = "Harpoon: go to file " .. i,
      })
    end
    return keys
  end,
  config = function()
    require("harpoon"):setup()
  end,
}
