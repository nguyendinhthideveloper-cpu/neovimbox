-- SPDX-License-Identifier: Apache-2.0
-- Copyright 2026 thind
-- In-editor cheatsheet: `:NvxHelp` (or <leader>?) opens a floating window with the
-- most-used keys. The full wiki lives in the repo under docs/ (keybindings.md etc.).
-- Content is kept in sync with docs/keybindings.md by hand — update both together.

local M = {}

local lines = {
  "# nvx cheatsheet    (q to close · full docs: docs/keybindings.md)",
  "",
  "<leader> is <Space>. Press <leader> and wait for which-key hints.",
  "LSP keys work only once a server has attached (:LspInfo).",
  "",
  "## Files & find",
  "  <leader>e     toggle file tree      <C-h>/<C-l>  focus tree / file",
  "  <leader>ff    find files            <leader>fg   live grep (ripgrep)",
  "  <leader>fb    buffers               <leader>fr   recent files",
  "  <leader>fR    find & replace        <leader>o    outline (symbols)",
  "  s / S         flash jump / treesitter jump",
  "",
  "## Code (LSP — use gd, NOT <C-]>)",
  "  gd  definition   gr  references   gI  implementation   K  hover",
  "  <leader>rn rename   <leader>ca code action   <leader>cf/<leader>f format",
  "  [d / ]d   prev / next diagnostic",
  "",
  "## Git",
  "  <leader>gg  neogit       <leader>gd  diff view    <leader>gh  file history",
  "  <leader>gl  git graph    ]c / [c     next/prev hunk",
  "  <leader>hs stage  <leader>hr reset  <leader>hp preview  <leader>hb blame",
  "",
  "## Buffers / windows",
  "  [b / ]b  prev/next buffer   <leader>bd close   <leader>bp pin",
  "  <C-h/j/k/l>  move between splits",
  "",
  "## Run / test / debug",
  "  <C-\\>  float terminal   <leader>tt test nearest   <leader>tr test file",
  "  <leader>tw watch   F5 continue   F10/F11/F12 step over/into/out",
  "  <leader>db breakpoint   <leader>du debug UI",
  "",
  "## Diagnostics (trouble)",
  "  <leader>xx project   <leader>xX buffer   <leader>xs symbols   <leader>xt todo",
  "",
  "## Marks / folds / session",
  "  <leader>ma pin  <C-e> menu  <leader>m1..4 jump   zR/zM open/close folds",
  "  <leader>ss save session   <leader>sr restore",
  "",
  "## AI (CodeCompanion — needs ANTHROPIC_API_KEY)",
  "  <leader>ac chat   <leader>aa actions   <leader>ai inline edit",
  "",
  "Full guides: docs/keybindings.md · docs/tools.md · docs/ai.md · docs/troubleshooting.md",
}

function M.open()
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].filetype = "markdown"

  local width = math.min(84, vim.o.columns - 4)
  local height = math.min(#lines + 2, vim.o.lines - 4)
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    style = "minimal",
    border = "rounded",
    title = " nvx help ",
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
