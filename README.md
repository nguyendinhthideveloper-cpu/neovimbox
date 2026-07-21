# neovimbox (`nvx`) — a portable Neovim IDE in a sandbox

[![CI](https://github.com/nguyendinhthideveloper-cpu/neovimbox/actions/workflows/ci.yml/badge.svg)](https://github.com/nguyendinhthideveloper-cpu/neovimbox/actions/workflows/ci.yml)
[![License: Apache-2.0](https://img.shields.io/badge/license-Apache--2.0-blue.svg)](LICENSE)

`nvx` turns **Neovim into a full multi-language IDE** (LSP, format, lint, debug, file tree, buffer tabs, integrated terminal, git UI, outline, breadcrumbs, diagnostics, test runner, AI) — packaged neatly inside **a single `~/.nvx` directory**. No Docker, nothing touches your machine, and removal leaves it clean.

- **Lightweight**: ~490MB core (Neovim + Node + mise). Languages are loaded on demand, sharing one mise instance (no duplication).
- **Sandbox**: everything lives under `~/.nvx` via `XDG_*`/`MISE_*`. The only trace on your machine: the `~/.local/bin/nvx` symlink.
- **Multi-language via [mise](https://mise.jdx.dev)**: add/change any version — `nvx add-tool java@25 maven@3.9.6`.
- **Clean removal**: `nvx uninstall` → deletes `~/.nvx`, leaving no trace on your machine.

---

## Installation (macOS / Linux / WSL)

```bash
git clone <repo-url> && cd <repo>
./install.sh          # install mise -> Neovim/Node/ripgrep/fd -> nvim config (one-time)
exec $SHELL           # load the new PATH (or open a new terminal)
nvx                   # open Neovim — IDE ready
```

> **Prerequisite** (the sandbox needs no root): `git`, `curl`, `unzip`, and a C compiler (Ubuntu: `sudo apt install build-essential`; macOS: `xcode-select --install`) — needed for treesitter parsers, rust-link, cgo, clangd. `install.sh` warns if any are missing.

---

## Using `nvx`

| Command | Purpose |
|---|---|
| `nvx` | open Neovim (in the sandbox) |
| `nvx add <lang> [ver]` | add a language: **go · python · rust · jvm · node · cpp** (runtime + LSP + format + lint + DAP) |
| `nvx add-tool <tool[@ver]...>` | add any CLI tool/version via mise (docker-cli, kubectl, helm, k9s, gh, lazygit, yq, java@25, maven@3.9.6...) |
| `nvx exec <cmd...>` | run a command in the sandbox env (e.g. `nvx exec java -version`, `nvx exec mvn package`) |
| `nvx shell` | open a shell with the sandbox environment (nvim, go... all use the sandbox build) |
| `nvx rm <tool>` | remove a runtime/tool |
| `nvx list` | list what is installed |
| `nvx update` | upgrade tools (mise) + sync Neovim plugins |
| `nvx doctor` | check prerequisites (cc/unzip/git) + tool versions in the sandbox |
| `nvx version` | print mise / nvim / node versions |
| `nvx uninstall` | **CLEAN REMOVAL** of the entire sandbox + the nvx command |

Examples:
```bash
nvx add go                     # Go + gopls + gofumpt + golangci-lint + delve
nvx add python 3.12            # Python 3.12 + pyright + ruff + black + debugpy
nvx add-tool java@25 maven@3.9.6 docker-cli kubectl
nvx exec go version
nvx exec mise ls-remote java   # see the available java versions
```

> **C/C++**: `nvx add cpp` installs clangd/clang-format/codelldb (LSP/format/debug); the compiler (gcc/clang) comes from the host. **DB clients** (psql/mysql/redis) are OS packages → install them from the host, not via `nvx`.

---

## How the sandbox works (why "removing one directory is clean")

Both Neovim and mise let you relocate where they read/write via environment variables. `nvx` points all of them into `~/.nvx`:

| Variable | Tool | Normally | `nvx` forces to |
|---|---|---|---|
| `XDG_CONFIG_HOME` | Neovim | `~/.config/nvim` | `~/.nvx/config/nvim` |
| `XDG_DATA_HOME` | Neovim | `~/.local/share/nvim` (plugins, mason LSP) | `~/.nvx/data/nvim` |
| `XDG_STATE/CACHE_HOME` | Neovim | `~/.local/state`, `~/.cache` | `~/.nvx/state`, `/cache` |
| `MISE_DATA_DIR` | mise | `~/.local/share/mise` (runtimes + shims) | `~/.nvx/mise` |
| `MISE_CONFIG_DIR` | mise | `~/.config/mise` | `~/.nvx/config/mise` |

On each invocation, `nvx` sets these variables before running `nvim`/`mise` → Neovim, plugins, LSP, and every runtime **all land under `~/.nvx`**, never touching your machine's `~/.config`, `~/.local/share`, or `.bashrc`. That is why `nvx uninstall` only needs `rm -rf ~/.nvx` + removing the symlink to leave your machine spotless.

```
~/.nvx/
├── bin/      mise · nvx · nvx-lang
├── mise/     installed runtimes + shims (nvim, node, go, java...)
├── config/   nvim/ (config) + mise/config.toml
├── data/     nvim/ (plugins, mason LSP, treesitter parsers)
└── state/  · cache/
```

> This is a **directory/environment-level** sandbox (file isolation, compact, easy to remove), NOT kernel isolation like a container — it still runs on your machine's OS/glibc, under your user's permissions.

---

## Neovim — key shortcuts

`<leader>` = **Space**. Press `<leader>` then wait for which-key to suggest.

| Group | Keys | Action |
|---|---|---|
| Find | `<leader>e` · `ff` · `fg` · `fb` | explorer · find file · grep · buffer |
| LSP | `gd` · `gr` · `K` · `<leader>rn` · `<leader>ca` · `[d`/`]d` | definition · references · hover · rename · code action · diagnostic |
| Format/Lint | `<leader>cf` · _(automatic on save)_ | format range/file |
| Debug | `<F5>` · `<F10/11/12>` · `<leader>db` · `<leader>du` | continue · step · breakpoint · DAP UI |
| Git | `<leader>gg` · `<leader>gd` · `<leader>hs`/`hr` | neogit · diff · stage/reset hunk |
| Test | `<leader>tt` · `<leader>tr` · `<leader>td` | test function · file · debug (Go/Python) |
| IDE | `[b`/`]b` · `<C-\>` · `<leader>o` · `<leader>xx` | buffer tabs · terminal · outline · diagnostics |
| AI | `<leader>ac` · `<leader>aa` · `<leader>ai` | chat · actions · inline (needs `ANTHROPIC_API_KEY`) |

LSP/formatter/linter **enable themselves based on the languages present** (the config detects executables on PATH), so the same configuration works correctly no matter which language you add. Manage plugins: `:Lazy` · Manage LSP/tools: `:Mason`.

---

## Reproducibility & pinning versions

- **Toolchain**: `nvx exec mise lock` generates `mise.lock` (pins versions + checksums). Change any version via `nvx add-tool <tool>@<ver>`.
- **Neovim plugins**: commits are locked in [`nvim/lazy-lock.json`](nvim/lazy-lock.json). Upgrade: `nvx update` then commit the new lock.
- **Moving machines**: `git clone` + `./install.sh` → rebuilds an identical sandbox.

## Repo structure
```
install.sh          bootstrap: build the ~/.nvx sandbox (one-time)
nvx                 CLI: open Neovim + add/add-tool/exec/shell/rm/list/update/uninstall
                    (language-install logic is the lang_add function inside)
nvim/               Neovim config (init.lua, ftplugin/, lua/config, lua/plugins)
```

Contributing: see [CONTRIBUTING.md](CONTRIBUTING.md) · [Code of Conduct](CODE_OF_CONDUCT.md) · report security issues via [SECURITY.md](SECURITY.md).

## License

[Apache License 2.0](LICENSE).
