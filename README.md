# neovimbox (`nvx`)

[![CI](https://github.com/nguyendinhthideveloper-cpu/neovimbox/actions/workflows/ci.yml/badge.svg)](https://github.com/nguyendinhthideveloper-cpu/neovimbox/actions/workflows/ci.yml)
[![License: Apache-2.0](https://img.shields.io/badge/license-Apache--2.0-blue.svg)](LICENSE)

A small tool that sets up Neovim as a multi-language editing environment inside a
single directory (`~/.nvx`). It's a Neovim config plus an installer built on
[mise](https://mise.jdx.dev) — no Docker, and `nvx uninstall` removes everything.

Languages are added on demand (`nvx add go`), so the base stays small (~490MB:
Neovim + Node + mise). Works on Linux, macOS, and WSL.

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/nguyendinhthideveloper-cpu/neovimbox/main/install.sh | bash
# or: git clone https://github.com/nguyendinhthideveloper-cpu/neovimbox && cd neovimbox && ./install.sh
```

Then open a new shell and run `nvx`. Needs `git`, `curl`, `unzip`, and a C compiler
(`build-essential` on Debian/Ubuntu, `xcode-select --install` on macOS) for
treesitter/rust/cgo/clangd; `install.sh` warns if any are missing.

## Commands

| Command | Purpose |
|---|---|
| `nvx` | open Neovim |
| `nvx add <lang> [ver]` | add a language (go / python / rust / jvm / node / cpp): runtime + LSP/format/lint/DAP |
| `nvx add-tool <tool[@ver]...>` | add a CLI tool via mise (docker-cli, kubectl, gh, lazygit, ...) |
| `nvx exec <cmd...>` | run a command in the sandbox env (e.g. `nvx exec go version`) |
| `nvx shell` | open a shell with the sandbox env |
| `nvx rm / list / update` | remove a tool / list installed / upgrade |
| `nvx doctor / version` | check prerequisites / print versions |
| `nvx uninstall` | remove the sandbox and the `nvx` command |

C/C++: `nvx add cpp` sets up clangd/clang-format/codelldb; the compiler comes from
the host. DB clients (psql/mysql/redis) are OS packages — install them from the host.

## How it works

`nvx` sets Neovim's `XDG_*` and mise's `MISE_*` variables to point into `~/.nvx`
before running anything, so config, plugins, LSP servers, and runtimes all stay in
that one directory instead of `~/.config` / `~/.local/share`. The only thing on the
host is the `~/.local/bin/nvx` symlink, so `nvx uninstall` is just `rm -rf ~/.nvx`
plus removing that link. It's directory-level isolation, not a container.

```
~/.nvx/  ├─ bin (mise, nvx)  ├─ mise (runtimes + shims)  ├─ config (nvim, mise)
         ├─ data (plugins, LSP, parsers)  └─ state · cache
```

## Neovim

`<leader>` is Space; press it and which-key shows the available keys. LSP,
formatting, linting, and debugging turn on per language automatically. Plugins are
pinned in [`nvim/lazy-lock.json`](nvim/lazy-lock.json); `:Lazy` / `:Mason` to manage.

## Repo

```
install.sh   installer (builds ~/.nvx)
nvx          the CLI (language install lives in the lang_add function)
nvim/        Neovim config
```

Contributing: [CONTRIBUTING.md](CONTRIBUTING.md) · [Code of Conduct](CODE_OF_CONDUCT.md) · [Security](SECURITY.md).

## License

[Apache-2.0](LICENSE).
