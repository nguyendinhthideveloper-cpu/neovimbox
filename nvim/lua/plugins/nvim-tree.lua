-- SPDX-License-Identifier: Apache-2.0
-- Copyright 2026 thind
return {
  "nvim-tree/nvim-tree.lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Toggle file explorer" },
  },
  -- Runs at startup even though the plugin is lazy: if nvim opens a directory
  -- (`nvx .`, `nvim <dir>`), cd into it and open the tree — an IDE-style view
  -- instead of netrw. netrw itself is disabled early in init.lua.
  init = function()
    vim.api.nvim_create_autocmd("VimEnter", {
      callback = function(data)
        if vim.fn.isdirectory(data.file) ~= 1 then
          return
        end
        vim.cmd.cd(data.file)
        require("nvim-tree.api").tree.open()
      end,
    })
  end,
  config = function()
    require("nvim-tree").setup({
      view = { width = 32 },
      renderer = { group_empty = true },
      filters = { dotfiles = false },
      git = { enable = true },
    })
  end,
}
