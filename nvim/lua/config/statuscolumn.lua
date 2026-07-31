-- SPDX-License-Identifier: Apache-2.0
-- Copyright 2026 thind
-- Gutter layout: sign -> number -> fold -> text.
--
-- Vim's built-in gutter order is fixed (fold -> number -> sign -> text), so an
-- always-on 'signcolumn' sits between the line number and the code and is empty
-- on nearly every line. That pushes the number two cells away from the text and
-- no combination of options can move it back. A 'statuscolumn' is the only way
-- to reorder the components, so we put the number last, next to the code, and
-- keep the fold cell (which actually has content in folded code) beside it.
--
-- We render the sign and fold cells with the NATIVE %s and %C items instead of
-- reading extmarks ourselves: diagnostics, DAP breakpoints and gitsigns keep
-- drawing exactly as they do without a 'statuscolumn', and there is nothing to
-- cache or throttle.
local M = {}

-- `%!` output is not highlighted for us, so we pick the groups by hand. A
-- colorscheme is free to leave the relative-number groups undefined, so resolve
-- them once and fall back to LineNr. Cached because this runs per line, per redraw.
local hl_cache = {}

local function hl(name)
  local resolved = hl_cache[name]
  if resolved == nil then
    local ok, def = pcall(vim.api.nvim_get_hl, 0, { name = name })
    resolved = (ok and next(def) ~= nil) and name or "LineNr"
    hl_cache[name] = resolved
  end
  return resolved
end

vim.api.nvim_create_autocmd("ColorScheme", {
  desc = "Re-resolve statuscolumn highlight groups for the new colorscheme",
  callback = function()
    hl_cache = {}
  end,
})

-- The number field must be the same width on every line of a buffer, otherwise
-- the text column would jag from line to line. Derive it from the buffer's line
-- count (not from the relative numbers, which are bounded by the window height)
-- so the absolute number on the cursor line always fits.
local function number_width(buf)
  return math.max(3, #tostring(vim.api.nvim_buf_line_count(buf)))
end

local function number(win, buf)
  local number_on, relative_on = vim.wo[win].number, vim.wo[win].relativenumber
  if not number_on and not relative_on then
    return ""
  end

  local width = number_width(buf)
  -- Wrapped rows and virtual lines are not real buffer lines; numbering them
  -- repeats the same number down the gutter.
  if vim.v.virtnum ~= 0 then
    return (" "):rep(width)
  end

  local cursor = vim.api.nvim_win_get_cursor(win)[1]
  local on_cursor_line = vim.v.lnum == cursor
  local text, group

  if on_cursor_line then
    -- With `relativenumber` the cursor line is the one line showing an absolute
    -- number, so right-aligning it would park a wide number under narrow ones
    -- and its left edge would drift as the file grows. Left-align it instead.
    -- Without `relativenumber` every line is absolute and equally wide, so
    -- right-aligning throughout is what keeps the column straight.
    local align = relative_on and "%-" or "%"
    text = (align .. width .. "d"):format(number_on and vim.v.lnum or 0)
    group = hl("CursorLineNr")
  else
    -- Right-aligned so the number hugs the text.
    text = ("%" .. width .. "d"):format(relative_on and vim.v.relnum or vim.v.lnum)
    group = hl(vim.v.lnum < cursor and "LineNrAbove" or "LineNrBelow")
  end

  return "%#" .. group .. "#" .. text .. "%*"
end

function M.render()
  -- statusline_winid can be stale or unset; an error in here is raised on every
  -- redraw of every line, so bail out quietly instead.
  local win = vim.g.statusline_winid
  if type(win) ~= "number" or not vim.api.nvim_win_is_valid(win) then
    return ""
  end
  local ok, segment = pcall(number, win, vim.api.nvim_win_get_buf(win))
  return "%s" .. (ok and segment or "") .. "%C"
end

-- Referenced by 'statuscolumn' as %!v:lua.nvx_statuscolumn(). The `%!` form is
-- required: it makes Neovim re-parse %s, %C and %#Group# in the returned string
-- as statusline items rather than printing them literally.
_G.nvx_statuscolumn = M.render

return M
