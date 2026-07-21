-- SPDX-License-Identifier: Apache-2.0
-- Copyright 2026 thind
-- Load mason early (lazy=false) so the :Mason / :MasonInstall commands always exist,
-- even when running headless during image build (scripts/install-<lang>.sh calls +MasonInstall).
return {
  "williamboman/mason.nvim",
  lazy = false,
  build = ":MasonUpdate",
  opts = {
    ui = { border = "rounded" },
  },
}
