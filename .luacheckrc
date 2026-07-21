-- Lint config for Neovim Lua (luajit + global `vim`).
std = "luajit"
globals = { "vim" }
-- Neovim config often has long lines + long strings -> don't enforce line length.
max_line_length = false
-- Ignore a few low-value warnings common in editor config:
ignore = {
  "212", -- unused argument (callbacks often take extra args)
  "631", -- line too long (already disabled max_line_length, but just in case)
}
