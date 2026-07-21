-- SPDX-License-Identifier: Apache-2.0
-- Copyright 2026 thind
-- Session: auto save/restore buffers + layout per project directory.
-- The has_ui guard in config -> only sets up when a real UI is present; headless (build/smoke)
-- loads the module but registers no autocmds. The plugin is still pre-installed into the image.
return {
  "rmagatti/auto-session",
  lazy = false,
  keys = {
    { "<leader>ss", "<cmd>SessionSave<cr>", desc = "Save session" },
    { "<leader>sr", "<cmd>SessionRestore<cr>", desc = "Restore session" },
  },
  config = function()
    if #vim.api.nvim_list_uis() == 0 then
      return -- headless: no auto-save/restore
    end
    require("auto-session").setup({
      auto_session_suppress_dirs = { "~/", "/", "/tmp" },
      auto_restore_enabled = true,
      auto_save_enabled = true,
    })
  end,
}
