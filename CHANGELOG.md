# Changelog

## 1.0.0 (2026-07-21)


### Features

* add git graph, in-editor help, and docs wiki ([bc79cec](https://github.com/nguyendinhthideveloper-cpu/neovimbox/commit/bc79cec891c9dc787c8da80d2650a86d654e8cf4))
* add git graph, in-editor help, and docs wiki ([4c2aa28](https://github.com/nguyendinhthideveloper-cpu/neovimbox/commit/4c2aa2877e496765c8f5b02981004b1dce318755))
* curl one-liner install + macOS CI + multi-distro prereq hints ([d622b57](https://github.com/nguyendinhthideveloper-cpu/neovimbox/commit/d622b576c879d53da1834e8fc69a6f6084086103))
* install a Nerd Font on setup + NVX_NERD_FONT icon toggle ([f9f04bf](https://github.com/nguyendinhthideveloper-cpu/neovimbox/commit/f9f04bfcdd8e6552ba461d34a22e71b48cba5fc6))
* **install:** auto-select the Nerd Font in Windows Terminal on WSL ([f5e9419](https://github.com/nguyendinhthideveloper-cpu/neovimbox/commit/f5e94193d4c1a451e379c2a6aa09a7a6f3102970))
* neovimbox — native Neovim IDE in a ~/.nvx sandbox ([9de1160](https://github.com/nguyendinhthideveloper-cpu/neovimbox/commit/9de11601d1da1e3c70a82c775a6303341fdf9a20))
* **nvx:** add `self-update` to sync nvx + config from the repo ([d9e33c9](https://github.com/nguyendinhthideveloper-cpu/neovimbox/commit/d9e33c9e474b0d466e886a20a18a0bf9a3641e99))
* **nvx:** forward nvim flags/Ex commands to Neovim ([4a3bf66](https://github.com/nguyendinhthideveloper-cpu/neovimbox/commit/4a3bf66bb0fb141a581ef0e49aec11301743fd83))
* **nvx:** open a path directly (`nvx .`, `nvx <dir|file>`) ([d53b3da](https://github.com/nguyendinhthideveloper-cpu/neovimbox/commit/d53b3dae5a26854e8b340405a1dc097ce01e35a7))


### Bug Fixes

* **ci:** make install.sh/nvx executable + resolve shellcheck SC2015 ([f82e19a](https://github.com/nguyendinhthideveloper-cpu/neovimbox/commit/f82e19a275da4ead0fdedee496c0828dfb665743))
* **install:** extract font via PowerShell on WSL (no unzip dependency) ([6acee61](https://github.com/nguyendinhthideveloper-cpu/neovimbox/commit/6acee610fa8f369878ffb436357b49e2b25c65d2))
* **install:** harden WSL Nerd Font install + honest fallback ([6f5c84d](https://github.com/nguyendinhthideveloper-cpu/neovimbox/commit/6f5c84d7ad601407db16c3e753dd787f40ba9ab5))
* **install:** install Windows font via PowerShell (root-cause fix) ([61ed7ec](https://github.com/nguyendinhthideveloper-cpu/neovimbox/commit/61ed7ec245909b6fd7eac08da03b408cd17bc6b6))
* **install:** rewrite two `A && B || C` idioms flagged by shellcheck … ([53b98ed](https://github.com/nguyendinhthideveloper-cpu/neovimbox/commit/53b98ed5d9175a7d7bcc9c36db3330fc9c353f23))
* **install:** rewrite two `A && B || C` idioms flagged by shellcheck (SC2015) ([ac5cc74](https://github.com/nguyendinhthideveloper-cpu/neovimbox/commit/ac5cc744766b2d7fb28772ab3a1afee152b35647))
* **nvim:** open dir as IDE split (tree left + editor right) ([6fe6c55](https://github.com/nguyendinhthideveloper-cpu/neovimbox/commit/6fe6c5577e102f3f280ff45d55883d17c3c5bc90))
* **nvim:** open nvim-tree (not netrw) when launched on a directory ([bb66197](https://github.com/nguyendinhthideveloper-cpu/neovimbox/commit/bb66197ca9946e4b4d150ca2a407ec109315d8b1))
* **nvim:** self-heal phantom NvimTree buffers on session restore ([ff10752](https://github.com/nguyendinhthideveloper-cpu/neovimbox/commit/ff1075286e03286b8f6efc35035fbdfb6470eb05))
* **nvim:** stop auto-session restoring a broken NvimTree buffer ([f3cd69c](https://github.com/nguyendinhthideveloper-cpu/neovimbox/commit/f3cd69c442803d13dbf1222cd70eb8210ded3161))
* **nvx:** show per-directory progress while uninstalling ([2b2d553](https://github.com/nguyendinhthideveloper-cpu/neovimbox/commit/2b2d55300ad7d46262bda064435174bf0d2d6891))
* **nvx:** show progress during uninstall so it doesn't look hung ([c21713a](https://github.com/nguyendinhthideveloper-cpu/neovimbox/commit/c21713afdb36026210ba01bbc8d0a974ddd7c61c))


### Performance Improvements

* **nvx:** make uninstall return instantly (rename + background delete) ([0ce2d61](https://github.com/nguyendinhthideveloper-cpu/neovimbox/commit/0ce2d616b8d1563cca5fa93ace615ce2b500e4a6))
* **nvx:** wipe sandbox subtrees in parallel on uninstall ([e8f9371](https://github.com/nguyendinhthideveloper-cpu/neovimbox/commit/e8f9371e4691eb4a8d8cf447ea7ab236f3e7af2f))

## Changelog

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
