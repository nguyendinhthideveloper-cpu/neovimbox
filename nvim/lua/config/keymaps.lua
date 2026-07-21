-- SPDX-License-Identifier: Apache-2.0
-- Copyright 2026 thind
local map = vim.keymap.set

-- Quick save / quit
map("n", "<leader>w", "<cmd>w<cr>", { desc = "Save file" })
map("n", "<leader>q", "<cmd>q<cr>", { desc = "Close window" })

-- Clear search highlight
map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })

-- Move between splits
map("n", "<C-h>", "<C-w>h", { desc = "Left split" })
map("n", "<C-j>", "<C-w>j", { desc = "Lower split" })
map("n", "<C-k>", "<C-w>k", { desc = "Upper split" })
map("n", "<C-l>", "<C-w>l", { desc = "Right split" })

-- Keep selection while indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Move the selected lines
map("v", "J", ":m '>+1<cr>gv=gv", { desc = "Move line down" })
map("v", "K", ":m '<-2<cr>gv=gv", { desc = "Move line up" })
