-- SPDX-License-Identifier: Apache-2.0
-- Copyright 2026 thind
-- Leader must be set BEFORE lazy loads so plugin keymaps register correctly
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Disable netrw at startup (before any directory buffer can load) so nvim-tree
-- owns directories — otherwise `nvim <dir>` / `nvx .` opens the netrw explorer.
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Icons need a Nerd Font (install.sh installs JetBrainsMono). On by default;
-- set NVX_NERD_FONT=0 to fall back to plain text if you have no Nerd Font.
vim.g.have_nerd_font = os.getenv("NVX_NERD_FONT") ~= "0"

require("config.options")
require("config.keymaps")
require("config.help")

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Load every spec in lua/plugins/
require("lazy").setup("plugins", {
  change_detection = { notify = false },
  ui = { border = "rounded" },
})
