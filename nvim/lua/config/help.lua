-- SPDX-License-Identifier: Apache-2.0
-- Copyright 2026 thind
-- In-editor cheatsheet: `:NvxHelp` (or <leader>?) opens a floating window with the
-- most-used keys. The full wiki lives in the repo under docs/ (keybindings.md etc.).
-- Content is kept in sync with docs/keybindings.md by hand — update both together.
-- Edit the `sections` table below; the rendered lines are generated from it.

local M = {}

-- Layout: one row carries two {key, desc} pairs on a fixed grid, so columns
-- cannot drift as entries are added. 2 + 14 + 25 + 14 + desc <= 78 columns.
local ROW_FMT = "  %-14s%-25s%-14s%s"
local HINT = "q to close · j/k or <C-d>/<C-u> to scroll · docs/keybindings.md"

local intro = {
  "<leader> is <Space>. Press <leader> and wait for which-key hints.",
  "LSP keys work only once a server has attached (:LspInfo).",
}

local sections = {
  {
    name = "Files & find",
    keys = {
      { "<leader>e", "toggle file tree" },
      { "<C-h>/<C-l>", "focus tree / file" },
      { "<leader>ff", "find files" },
      { "<leader>fg", "live grep (ripgrep)" },
      { "<leader>fb", "buffers" },
      { "<leader>fr", "recent files" },
      { "<leader>fR", "find & replace" },
      { "<leader>o", "outline (symbols)" },
      { "s", "flash jump" },
      { "S", "treesitter jump" },
    },
  },
  {
    name = "Code (LSP — use gd, NOT <C-]>)",
    keys = {
      { "gd", "definition" },
      { "gr", "references" },
      { "gI", "implementation" },
      { "K", "hover" },
      { "<leader>rn", "rename" },
      { "<leader>ca", "code action" },
      { "<leader>cf", "format" },
      { "<leader>f", "format (alias)" },
      { "[d / ]d", "prev / next diagnostic" },
    },
  },
  {
    name = "Git",
    keys = {
      { "<leader>gg", "neogit" },
      { "<leader>gd", "diff view" },
      { "<leader>gh", "file history" },
      { "<leader>gl", "git graph" },
      { "]c / [c", "next/prev hunk" },
      { "<leader>hs", "stage" },
      { "<leader>hr", "reset" },
      { "<leader>hp", "preview" },
      { "<leader>hb", "blame" },
    },
  },
  {
    name = "Buffers / windows",
    keys = {
      { "[b / ]b", "prev/next buffer" },
      { "<leader>bd", "close" },
      { "<leader>bp", "pin" },
      { "<C-h/j/k/l>", "move between splits" },
    },
  },
  {
    name = "Run / test / debug",
    keys = {
      { "<C-\\>", "float terminal" },
      { "<leader>tt", "test nearest" },
      { "<leader>tr", "test file" },
      { "<leader>tw", "watch" },
      { "F5", "continue" },
      { "F10/F11/F12", "step over/into/out" },
      { "<leader>db", "breakpoint" },
      { "<leader>du", "debug UI" },
    },
  },
  {
    name = "Diagnostics (trouble)",
    keys = {
      { "<leader>xx", "project" },
      { "<leader>xX", "buffer" },
      { "<leader>xs", "symbols" },
      { "<leader>xt", "todo" },
    },
  },
  {
    name = "Marks / folds / session",
    keys = {
      { "<leader>ma", "pin" },
      { "<C-e>", "menu" },
      { "<leader>m1..4", "jump" },
      { "zR/zM", "open/close folds" },
      { "<leader>ss", "save session" },
      { "<leader>sr", "restore" },
    },
  },
  {
    name = "AI (CodeCompanion — needs ANTHROPIC_API_KEY)",
    keys = {
      { "<leader>ac", "chat" },
      { "<leader>aa", "actions" },
      { "<leader>ai", "inline edit" },
    },
  },
}

local outro = {
  "Full guides: docs/keybindings.md · docs/tools.md",
  "             docs/ai.md · docs/troubleshooting.md",
}

-- Build the buffer contents. Leading and trailing blank lines give the float
-- symmetric padding without fudging the window height.
local function render()
  local out = { "", HINT, "" }
  for _, line in ipairs(intro) do
    table.insert(out, line)
  end
  for _, section in ipairs(sections) do
    table.insert(out, "")
    table.insert(out, "## " .. section.name)
    for i = 1, #section.keys, 2 do
      local left = section.keys[i]
      local right = section.keys[i + 1] or { "", "" }
      local row = ROW_FMT:format(left[1], left[2], right[1], right[2])
      table.insert(out, (row:gsub("%s+$", "")))
    end
  end
  table.insert(out, "")
  for _, line in ipairs(outro) do
    table.insert(out, line)
  end
  table.insert(out, "")
  return out
end

M.lines = render()

function M.open()
  local lines = M.lines
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].filetype = "markdown"

  local width = math.min(84, vim.o.columns - 4)
  local height = math.min(#lines, vim.o.lines - 4)
  -- `style = "minimal"` has no scrollbar, so say it in the title when the
  -- content does not fit — otherwise the tail is silently invisible.
  local title = " nvx help "
  if height < #lines then
    title = " nvx help · more below (j/k, <C-d>/<C-u>) "
  end
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    style = "minimal",
    border = "rounded",
    title = title,
    title_pos = "center",
  })
  vim.wo[win].wrap = false

  -- q or <Esc> closes the window
  for _, key in ipairs({ "q", "<Esc>" }) do
    vim.keymap.set("n", key, "<cmd>close<cr>", { buffer = buf, nowait = true, silent = true })
  end
end

vim.api.nvim_create_user_command("NvxHelp", M.open, { desc = "Show the nvx keybinding cheatsheet" })
vim.keymap.set("n", "<leader>?", M.open, { desc = "Help (nvx cheatsheet)" })

return M
