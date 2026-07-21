-- SPDX-License-Identifier: Apache-2.0
-- Copyright 2026 thind
-- Query databases right inside Neovim (uses available psql/mysql/redis-cli/sqlite3).
-- Open the UI: <leader>D. Add a connection: press `A` in DBUI, or set g:dbs / an env var.
return {
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      { "tpope/vim-dadbod", lazy = true },
      { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
    },
    cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
    keys = {
      { "<leader>D", "<cmd>DBUIToggle<cr>", desc = "Toggle Database UI" },
    },
    init = function()
      -- Save queries to ~/.local/share/db_ui, use native nvim windows
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_execute_on_save = 0 -- don't auto-run on save, avoids accidental heavy queries
      -- Example of a predeclared connection (uncomment and edit):
      -- vim.g.dbs = {
      --   { name = "local_pg", url = "postgres://user:pass@localhost:5432/mydb" },
      -- }
    end,
  },
}
