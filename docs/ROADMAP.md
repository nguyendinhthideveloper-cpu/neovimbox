# Roadmap — neovimbox (`nvx`)

Status: the native `nvx` build (`~/.nvx` sandbox) is complete & verified on Linux and macOS. Docker removed.

## P1 — Correct & solid
- [x] `nvx doctor` — check prerequisites (cc/unzip/git) + tools in the sandbox.
- [x] `nvx version` — print mise / nvim / node versions.
- [x] **Merge `poc/mise-base` → `main`** so CI (lint + smoke) runs officially — `main` is the default branch and CI runs on every push/PR.
- [x] **Test on macOS** (zsh + clang from xcode-select) — the `smoke-macos` job in `.github/workflows/ci.yml` runs the full install + `nvx` flow on `macos-latest`.

## P2 — Standardize / finalize
- [x] CI + License badges in the README.
- [x] `.github/ISSUE_TEMPLATE/` (bug + feature) + PR template.
- [x] Publish to GitHub as neovimbox (create repo + push); badge URLs point at `nguyendinhthideveloper-cpu/neovimbox`.
- [x] release-please shipped **1.0.0** (tag `v1.0.0`, see `CHANGELOG.md` / `.release-please-manifest.json`). *(runs automatically on merge)*

## P3 — Features (as needed)
- [x] `nvx update` upgrades Neovim too — `mise upgrade` already covers it (neovim installed as `@latest`).
- [ ] Add languages to `nvx`'s `lang_add` (zig / ruby / c# / php...) — also needs the corresponding server added to `nvim/lua/plugins/lsp.lua`.
- [ ] `nvx add-tool` alias/catalog suggesting popular tools.
- [ ] Windows-native support (hard because of nvim+LSP; WSL already covers most of it).

## Done (recent history)
- Moved the toolchain to **mise** (replacing pyenv/nvm/sdkman/rustup).
- Removed Docker entirely → a single-directory **native `~/.nvx` sandbox**, `nvx uninstall` removes it cleanly.
- Consolidated to 2 executables (`install.sh` + `nvx`).
- Standardized: LICENSE (Apache-2.0), CONTRIBUTING, CI lint+smoke, cleaned up Docker cruft.
