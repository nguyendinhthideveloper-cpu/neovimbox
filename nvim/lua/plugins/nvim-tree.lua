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
        -- Turn the directory buffer into an empty editor buffer (the right pane)
        -- and open nvim-tree as a left sidebar → IDE-style split, not full width.
        local dirbuf = data.buf
        vim.cmd.enew()
        pcall(vim.cmd.bwipeout, dirbuf)
        require("nvim-tree.api").tree.open()
      end,
    })
  end,
  config = function()
    local nf = vim.g.have_nerd_font
    require("nvim-tree").setup({
      hijack_directories = { enable = false }, -- our VimEnter autocmd builds the layout
      view = { width = 32 },
      renderer = {
        group_empty = true,
        -- hide glyph icons when there's no Nerd Font, so the tree stays readable
        icons = { show = { file = nf, folder = nf, folder_arrow = nf, git = nf } },
      },
      filters = { dotfiles = false },
      git = { enable = true },
    })
  end,
}
