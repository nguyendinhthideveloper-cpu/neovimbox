-- SPDX-License-Identifier: Apache-2.0
-- Copyright 2026 thind
local opt = vim.opt

opt.mouse = "a"
opt.clipboard = "unnamedplus" -- use OSC52 if the terminal supports it (see provider below)
opt.breakindent = true
opt.undofile = true
opt.ignorecase = true
opt.smartcase = true
opt.updatetime = 250
opt.timeoutlen = 300
opt.splitright = true
opt.splitbelow = true
opt.termguicolors = true
opt.cursorline = true
opt.scrolloff = 8

-- Default indent
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2

-- Gutter. ALL gutter layout lives here, including `foldcolumn` (nvim-ufo only
-- needs it non-zero, it does not care who sets it) so that reading this one
-- block tells you the whole story.
--
-- Vim's built-in column order is fixed: fold -> number -> sign -> text. With an
-- always-on sign column that leaves two permanently blank cells between the
-- line number and the code on every unsigned line. A 'statuscolumn' is the only
-- way to reorder them, so we render sign -> number -> fold instead (matching
-- VS Code, which puts fold controls between the numbers and the text).
opt.number = true
opt.relativenumber = true
-- With `relativenumber` the drawn number is bounded by the window height, so it
-- is nearly always 1-2 digits; 3 is enough and `statuscolumn` widens itself for
-- bigger buffers anyway.
opt.numberwidth = 3
-- Fixed rather than "auto": auto shifts the text sideways whenever a sign
-- appears or clears. gitsigns only ever draws one character, so one cell fits.
opt.signcolumn = "yes:1"
opt.foldcolumn = "1"
-- The `%!` form (rather than embedding the items directly) makes Neovim re-parse
-- %s / %C / %#Group# in the returned string as statusline items.
require("config.statuscolumn")
opt.statuscolumn = "%!v:lua.nvx_statuscolumn()"

-- Terminals have no meaningful line numbers, and toggleterm's float is narrow
-- enough that the gutter is real estate. Strip it entirely for terminal buffers.
vim.api.nvim_create_autocmd("TermOpen", {
  group = vim.api.nvim_create_augroup("nvx_term_gutter", { clear = true }),
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
    vim.opt_local.foldcolumn = "0"
    vim.opt_local.statuscolumn = ""
  end,
})

-- Containers have no system clipboard (X server). If the terminal supports OSC52,
-- yanking pushes to the host machine's clipboard via an escape sequence.
if vim.fn.has("nvim-0.10") == 1 then
  vim.g.clipboard = {
    name = "OSC52",
    copy = {
      ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
      ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
    },
    paste = {
      ["+"] = require("vim.ui.clipboard.osc52").paste("+"),
      ["*"] = require("vim.ui.clipboard.osc52").paste("*"),
    },
  }
end
