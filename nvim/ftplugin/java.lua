-- SPDX-License-Identifier: Apache-2.0
-- Copyright 2026 thind
-- Start jdtls for each Java project. Runs when filetype = java.
-- Skip if the image has no Java (non-JVM variant).
if vim.fn.executable("java") ~= 1 then
  return
end

local ok, jdtls = pcall(require, "jdtls")
if not ok then
  return
end

local mason = vim.fn.stdpath("data") .. "/mason/packages/jdtls"

-- launcher jar (name contains a version, so glob for it)
local launcher = vim.fn.glob(mason .. "/plugins/org.eclipse.equinox.launcher_*.jar", true)
if launcher == "" then
  vim.notify("jdtls is not installed (run :MasonInstall jdtls)", vim.log.levels.WARN)
  return
end

local os_config = "config_linux"
if vim.fn.has("mac") == 1 then
  os_config = "config_mac"
end

-- Determine the root from common Maven/Gradle build files
local root_markers = { "mvnw", "gradlew", "pom.xml", "build.gradle", "build.gradle.kts", ".git" }
local root_dir = require("jdtls.setup").find_root(root_markers)
if root_dir == "" or root_dir == nil then
  root_dir = vim.fn.getcwd()
end

-- Separate workspace per project
local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspace/" .. project_name

local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Load debug/test bundles (java-debug-adapter + java-test) from mason if present
local bundles = {}
local mason_pkgs = vim.fn.stdpath("data") .. "/mason/packages"
vim.list_extend(
  bundles,
  vim.split(
    vim.fn.glob(
      mason_pkgs .. "/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar",
      true
    ),
    "\n"
  )
)
vim.list_extend(
  bundles,
  vim.split(vim.fn.glob(mason_pkgs .. "/java-test/extension/server/*.jar", true), "\n")
)
-- Remove empty entries when not installed
bundles = vim.tbl_filter(function(v)
  return v ~= ""
end, bundles)

local config = {
  cmd = {
    "java",
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    "-Xmx1g",
    "--add-modules=ALL-SYSTEM",
    "--add-opens",
    "java.base/java.util=ALL-UNNAMED",
    "--add-opens",
    "java.base/java.lang=ALL-UNNAMED",
    "-jar",
    launcher,
    "-configuration",
    mason .. "/" .. os_config,
    "-data",
    workspace_dir,
  },
  root_dir = root_dir,
  capabilities = capabilities,
  settings = {
    java = {
      configuration = { updateBuildConfiguration = "interactive" },
      maven = { downloadSources = true },
      references = { includeDecompiledSources = true },
    },
  },
  init_options = { bundles = bundles },
  on_attach = function()
    -- Enable DAP for Java + auto-detect main class / test
    pcall(function()
      jdtls.setup_dap({ hotcodereplace = "auto" })
      require("jdtls.dap").setup_dap_main_class_configs()
    end)
  end,
}

jdtls.start_or_attach(config)
