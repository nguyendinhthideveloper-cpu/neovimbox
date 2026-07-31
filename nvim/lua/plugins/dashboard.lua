-- SPDX-License-Identifier: Apache-2.0
-- Copyright 2026 thind
-- Welcome screen shown when opening `nvim` without a file.
-- VimEnter fires even in headless mode -> guard: don't set up without a real UI
-- (avoids drawing the dashboard during build/smoke). The plugin is still preinstalled in the image.
return {
  "goolord/alpha-nvim",
  event = "VimEnter",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    if #vim.api.nvim_list_uis() == 0 then
      return -- headless: skip
    end
    local dashboard = require("alpha.themes.dashboard")

    -- alpha measures with vim.fn.strdisplaywidth (alpha.lua: longest_line), so `·`
    -- and Nerd Font glyphs count as one cell, not their 2-4 UTF-8 bytes. But
    -- align_center computes ONE left padding from the longest line and prepends it
    -- to every line, i.e. it centres the block, not each line. Shorter lines would
    -- hang to the left, so we centre them against the widest line ourselves first.
    local function center_block(lines)
      local widest = 0
      for _, line in ipairs(lines) do
        widest = math.max(widest, vim.fn.strdisplaywidth(line))
      end
      local out = {}
      for i, line in ipairs(lines) do
        local pad = math.floor((widest - vim.fn.strdisplaywidth(line)) / 2)
        out[i] = string.rep(" ", pad) .. line
      end
      return out
    end

    -- Plain text only: no hand-written padding to fight alpha's centring.
    dashboard.section.header.val = center_block({
      "neovimbox  ·  nvx",
      "Java · Python · Node · Go · Rust · C++",
    })

    -- init.lua sets vim.g.have_nerd_font from NVX_NERD_FONT; without a Nerd Font the
    -- glyphs render as tofu boxes, so fall back to blanks. A glyph is 1 cell + 2
    -- spaces = 3 cells, matched by 3 spaces, so labels line up in both modes.
    local nf = vim.g.have_nerd_font
    local function icon(glyph)
      return nf and (glyph .. "  ") or "   "
    end

    dashboard.section.buttons.val = {
      dashboard.button("f", icon("󰈞") .. "Find file", "<cmd>Telescope find_files<cr>"),
      dashboard.button("r", icon("󰋚") .. "Recent files", "<cmd>Telescope oldfiles<cr>"),
      dashboard.button("g", icon("󰱼") .. "Grep contents", "<cmd>Telescope live_grep<cr>"),
      dashboard.button("e", icon("") .. "New file", "<cmd>ene <BAR> startinsert<cr>"),
      dashboard.button("q", icon("") .. "Quit", "<cmd>qa<cr>"),
    }

    -- First-run pointer to the cheatsheet, so the welcome screen says where help is.
    -- Single line, so alpha's own centring is already correct for it.
    dashboard.section.footer.val = {
      icon("󰋖") .. "<leader>?  help (:NvxHelp)     <leader>ff  find file",
    }

    require("alpha").setup(dashboard.config)
  end,
}
