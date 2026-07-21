-- SPDX-License-Identifier: Apache-2.0
-- Copyright 2026 thind
-- Java is handled separately via nvim-jdtls (not set up through lspconfig).
-- The startup logic lives in ftplugin/java.lua, running each time a .java file is opened.
return {
  "mfussenegger/nvim-jdtls",
  ft = "java",
}
