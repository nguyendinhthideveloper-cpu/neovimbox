# Changelog

## Unreleased

Initial release — **neovimbox** (`nvx`): a native Neovim IDE packaged in a single
sandbox (`~/.nvx`), driven by [mise](https://mise.jdx.dev) + the `nvx` CLI.

### Features

- **`nvx`** CLI: open Neovim + `add` / `add-tool` / `exec` / `shell` / `rm` /
  `list` / `update` / `doctor` / `version` / `uninstall`.
- **Self-contained sandbox** in `~/.nvx` (points `XDG_*`/`MISE_*` there) — never
  touches `~/.config`, `~/.local/share`, or `.bashrc`. Clean removal via
  `nvx uninstall` (deletes one directory); the only host trace is the
  `~/.local/bin/nvx` symlink.
- **Multi-language via mise**: `go` / `python` / `rust` / `jvm` / `node` / `cpp`,
  each with a full LSP + formatter + linter + DAP (mason). Add/pin any version
  with `nvx add-tool <tool>@<ver>`.
- **Neovim IDE** (68 plugins, pinned via `nvim/lazy-lock.json`): LSP auto-enables
  per toolchain, format/lint on save, debug (DAP), git UI, treesitter, test
  runner, AI.

<!-- release-please prepends new entries above. -->
