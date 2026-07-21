-- SPDX-License-Identifier: Apache-2.0
-- Copyright 2026 thind
-- Leader must be set BEFORE lazy loads so plugin keymaps register correctly
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("config.options")
require("config.keymaps")

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
