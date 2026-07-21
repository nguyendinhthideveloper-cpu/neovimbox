<!-- SPDX-License-Identifier: Apache-2.0 -->
<!-- Copyright 2026 thind -->

# Languages & tools

`nvx` keeps the base image small and adds language support on demand. Two layers
cooperate:

1. **Runtimes** — installed by the `nvx` CLI via [mise](https://mise.jdx.dev).
2. **Editor tools** (LSP servers, formatters, linters, DAP adapters) — installed
   inside Neovim by [Mason](https://github.com/williamboman/mason.nvim), and
   auto-installed by
   [`mason-tools.lua`](../nvim/lua/plugins/mason-tools.lua) **only for toolchains
   that are actually present on `PATH`** — so one config works across every image.

## Add a language

```bash
nvx add go        # runtime + LSP/format/lint/DAP for Go
nvx add python
nvx add rust
nvx add jvm        # Java/Kotlin
nvx add cpp        # clangd/clang-format/codelldb (compiler from host)
nvx add node
```

Then open Neovim (`nvx`) and open a file of that language — the matching tools
install automatically on first launch.

## What auto-installs

Defined in [`mason-tools.lua`](../nvim/lua/plugins/mason-tools.lua):

| Toolchain detected | Tools installed |
|---|---|
| always | `stylua`, `prettierd`, `eslint_d` |
| `python` | `black`, `isort`, `ruff`, `debugpy` |
| `go` | `gofumpt`, `goimports`, `golangci-lint`, `delve` |
| `java` | `jdtls`, `java-debug-adapter`, `java-test`, `google-java-format` |
| `cargo` / `clangd` | `codelldb` (Rust / C / C++) |

Detection is simply "is the executable on `PATH`?"
(see [`toolchains.lua`](../nvim/lua/config/toolchains.lua)).

## Managing tools manually

| Command | Purpose |
|---|---|
| `:Mason` | Open the Mason UI (browse / install / update / remove) |
| `:MasonInstall <name>` | Install a specific tool, e.g. `:MasonInstall jdtls` |
| `:MasonToolsInstall` | Install everything `mason-tools` expects |
| `:MasonToolsUpdate` | Update the managed tools |
| `:Lazy` | Manage plugins (sync / update / clean) |
| `:LspInfo` | Show LSP servers attached to the current buffer |
| `:checkhealth` | Neovim's built-in diagnostics |

Big packages (e.g. `jdtls`) download in the background on first start. If you open
a file before the download finishes you may see a "not installed" warning — see
[troubleshooting.md](troubleshooting.md).

## Formatting & linting

- Formatting is on-save via [conform](../nvim/lua/plugins/conform.lua), or manual
  with `<leader>cf` / `<leader>f`.
- Linting runs via [nvim-lint](../nvim/lua/plugins/lint.lua) for detected
  toolchains.

## Java specifics

Java is handled by [`nvim-jdtls`](../nvim/lua/plugins/jdtls.lua), started from
[`ftplugin/java.lua`](../nvim/ftplugin/java.lua) each time a `.java` file opens. It
needs a JDK on `PATH` and the `jdtls` Mason package. Debug/test bundles
(`java-debug-adapter`, `java-test`) are picked up automatically when present.
