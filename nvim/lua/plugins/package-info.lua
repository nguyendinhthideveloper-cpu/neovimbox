-- SPDX-License-Identifier: Apache-2.0
-- Copyright 2026 thind
-- package.json: shows each dependency's current/latest version (virtual text).
return {
  "vuki656/package-info.nvim",
  event = { "BufRead package.json" },
  dependencies = { "MunifTanjim/nui.nvim" }, -- nui is already available (from noice)
  config = function()
    require("package-info").setup()
  end,
}
