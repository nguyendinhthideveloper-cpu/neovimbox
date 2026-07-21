# neovimbox (`nvx`)

[![CI](https://github.com/nguyendinhthideveloper-cpu/neovimbox/actions/workflows/ci.yml/badge.svg)](https://github.com/nguyendinhthideveloper-cpu/neovimbox/actions/workflows/ci.yml)
[![License: Apache-2.0](https://img.shields.io/badge/license-Apache--2.0-blue.svg)](LICENSE)

A small tool that turns [Neovim](https://github.com/neovim/neovim) into a
multi-language IDE inside a single directory (`~/.nvx`) — a Neovim config plus a
[mise](https://mise.jdx.dev)-based installer, no Docker.

Languages are added on demand (`nvx add go`), so the base stays small
(~490MB: Neovim + Node + mise), and `nvx uninstall` removes everything it
installed. Works on Linux, macOS, and WSL.

## Install

One-liner:

```bash
curl -fsSL https://raw.githubusercontent.com/nguyendinhthideveloper-cpu/neovimbox/main/install.sh | bash
```

Or from a clone:

```bash
git clone https://github.com/nguyendinhthideveloper-cpu/neovimbox
cd neovimbox && ./install.sh
```

Open a new shell, then:

```bash
nvx add go     # add a language: runtime + LSP/format/lint/DAP
nvx            # open Neovim
```

**Prerequisites:** `git`, `curl`, `unzip`, and a C compiler
(`build-essential` on Debian/Ubuntu, `xcode-select --install` on macOS) — needed
for treesitter, clangd, and cgo/rust. `install.sh` warns if any are missing;
`nvx doctor` re-checks them any time.

## Commands

| Command | Purpose |
|---|---|
| `nvx [path\|-flag\|+cmd]` | open Neovim — the cwd, a dir (`nvx .`), a file, or pass nvim flags through (`nvx +qa`, `nvx -R file`) |
| `nvx add <lang> [ver]` | add a language (go / python / rust / jvm / node / cpp): runtime + LSP/format/lint/DAP |
| `nvx add-tool <tool[@ver]...>` | add a CLI tool via mise (docker-cli, kubectl, gh, lazygit, …) |
| `nvx exec <cmd...>` | run a command in the sandbox env (e.g. `nvx exec go version`) |
| `nvx shell` | open a shell with the sandbox env |
| `nvx rm / list / update` | remove a tool / list installed / upgrade |
| `nvx self-update` | pull the latest `nvx` + Neovim config from GitHub into the sandbox |
| `nvx doctor / version / home` | check prerequisites / print versions / print the sandbox path |
| `nvx uninstall` | remove the sandbox and the `nvx` command |

nvim flags and Ex commands pass straight through — except `nvx --version`/`-v` and
`nvx --help`/`-h`, which report nvx itself; use `nvx nvim --version` for Neovim's.

C/C++: `nvx add cpp` sets up clangd/clang-format/codelldb; the compiler comes from
the host. DB clients (psql/mysql/redis) are OS packages — install them from the host.

## How it works

`nvx` points Neovim's `XDG_*` and mise's `MISE_*` variables into `~/.nvx` before
running anything, so config, plugins, LSP servers, and runtimes all stay in that
one directory instead of `~/.config` / `~/.local/share`. The only thing on the
host is the `~/.local/bin/nvx` symlink, so `nvx uninstall` is just
`rm -rf ~/.nvx` plus removing that link. It's directory-level isolation, not a
container. Set `NVX_HOME` to put the sandbox somewhere other than `~/.nvx`.

```
~/.nvx/
├─ bin/      mise, nvx
├─ mise/     language runtimes + shims
├─ config/   nvim + mise config
├─ data/     plugins, LSP servers, treesitter parsers
├─ state/    logs, undo history
└─ cache/    caches
```

## Neovim

`<leader>` is Space; press it and which-key shows the available keys, or run
`:NvxHelp` (`<leader>?`) for a cheatsheet. LSP, formatting, linting, and debugging
turn on per language automatically. Plugins are pinned in
[`nvim/lazy-lock.json`](nvim/lazy-lock.json); use `:Lazy` / `:Mason` to manage them.

Full docs live in [`docs/`](docs/README.md): [keybindings](docs/keybindings.md),
[languages & tools](docs/tools.md), [AI](docs/ai.md), and
[troubleshooting](docs/troubleshooting.md).

Icons need a [Nerd Font](https://www.nerdfonts.com). `install.sh` installs
JetBrainsMono Nerd Font for you and, on WSL, also sets it as the Windows Terminal
font automatically (backing up `settings.json`) — restart the terminal to see it.
Skip the whole thing with `NVX_NO_FONT=1`, or run with `NVX_NERD_FONT=0` for a
plain-text fallback instead of `◆`/`□` placeholders. On other terminals, select
`JetBrainsMono Nerd Font` yourself.

## Repo

```
install.sh   installer (builds ~/.nvx)
nvx          the CLI (language install lives in the lang_add function)
nvim/        Neovim config
docs/        wiki (keybindings, tools, AI, troubleshooting) + roadmap
```

Contributing: [CONTRIBUTING.md](CONTRIBUTING.md) · [Code of Conduct](CODE_OF_CONDUCT.md) · [Security](SECURITY.md).

## License

[Apache-2.0](LICENSE).
