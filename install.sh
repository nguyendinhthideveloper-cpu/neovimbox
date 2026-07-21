#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0
# Copyright 2026 thind
# ============================================================================
# install.sh — build a NATIVE Neovim IDE (Neovim + mise), packaged in ONE sandbox.
# No Docker, nothing touches your machine: everything lives under $NVX_HOME
# (default ~/.nvx) by pointing XDG_*/MISE_* there. The host gets a SINGLE symlink,
# the `nvx` command.
#
# Install (either way, Linux / macOS / WSL):
#   curl -fsSL https://raw.githubusercontent.com/nguyendinhthideveloper-cpu/neovimbox/main/install.sh | bash
#   # or: git clone https://github.com/nguyendinhthideveloper-cpu/neovimbox && cd neovimbox && ./install.sh
#
# Wipe everything (Neovim included): `nvx uninstall`  ->  deletes exactly $NVX_HOME.
# ============================================================================
set -euo pipefail

REPO_URL="https://github.com/nguyendinhthideveloper-cpu/neovimbox"
NVX_HOME="${NVX_HOME:-$HOME/.nvx}"
HOST_BIN="$HOME/.local/bin"
# Where this script sits (empty/"." when piped via curl | bash).
HERE="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" 2>/dev/null && pwd || true)"

info() { printf '\033[32m▸ %s\033[0m\n' "$*"; }
warn() { printf '\033[33m⚠ %s\033[0m\n' "$*" >&2; }

# 0) Prerequisites (can't auto-install — need root / differ per OS) -----------
miss=0
need() { command -v "$1" >/dev/null 2>&1 || { warn "missing '$1' — $2"; miss=1; }; }
need curl  "apt install curl · dnf install curl · brew install curl"
need git   "apt install git · dnf install git · pacman -S git · xcode-select --install"
need unzip "apt install unzip · dnf install unzip · pacman -S unzip · brew install unzip (mason needs it)"
if ! command -v cc >/dev/null 2>&1 && ! command -v gcc >/dev/null 2>&1 && ! command -v clang >/dev/null 2>&1; then
  warn "missing C compiler (cc/gcc/clang) — needed for treesitter/rust-link/cgo/cpp"
  warn "  Debian/Ubuntu: apt install build-essential · Fedora: dnf groupinstall 'Development Tools'"
  warn "  Arch: pacman -S base-devel · macOS: xcode-select --install"
  miss=1
fi
[ "$miss" -eq 0 ] || warn "Missing prerequisites above — continuing, but related parts may fail."

# 0.5) Source: run from a clone (script sits next to nvx+nvim), else fetch it --
if [ -n "$HERE" ] && [ -f "$HERE/nvx" ] && [ -d "$HERE/nvim" ]; then
  SRC="$HERE"
else
  SRC="$NVX_HOME/src"
  info "Fetching neovimbox ($REPO_URL)..."
  rm -rf "$SRC"; mkdir -p "$(dirname "$SRC")"
  git clone --depth 1 "$REPO_URL" "$SRC"
fi

# 1) Sandbox layout ----------------------------------------------------------
mkdir -p "$NVX_HOME"/bin "$NVX_HOME"/config "$NVX_HOME"/data \
         "$NVX_HOME"/state "$NVX_HOME"/cache "$NVX_HOME"/mise "$HOST_BIN"

# 2) Point all state at the sandbox (identical to the `nvx` command) ---------
export XDG_CONFIG_HOME="$NVX_HOME/config"
export XDG_DATA_HOME="$NVX_HOME/data"
export XDG_STATE_HOME="$NVX_HOME/state"
export XDG_CACHE_HOME="$NVX_HOME/cache"
export MISE_DATA_DIR="$NVX_HOME/mise"
export MISE_CONFIG_DIR="$NVX_HOME/config/mise"
export MISE_STATE_DIR="$NVX_HOME/state/mise"
export MISE_CACHE_DIR="$NVX_HOME/cache/mise"
export PATH="$NVX_HOME/bin:$NVX_HOME/mise/shims:$PATH"

# 3) mise (binary lives INSIDE the sandbox) ----------------------------------
if [ ! -x "$NVX_HOME/bin/mise" ]; then
  info "Installing mise into the sandbox..."
  curl -fsSL https://mise.run | MISE_INSTALL_PATH="$NVX_HOME/bin/mise" sh
fi

# 4) Neovim + Node + ripgrep + fd (all in the sandbox) -----------------------
info "Installing Neovim + Node + ripgrep + fd via mise..."
mise use -g neovim@latest node@20 ripgrep fd
mise reshim; hash -r 2>/dev/null || true

# 5) Copy Neovim config + command into the sandbox (self-contained) ----------
rm -rf "$NVX_HOME/config/nvim"
cp -r "$SRC/nvim" "$NVX_HOME/config/nvim"
cp "$SRC/nvx" "$NVX_HOME/bin/nvx"
chmod +x "$NVX_HOME/bin/nvx"
info "Config + command are now inside $NVX_HOME"

# 6) Host: a SINGLE symlink, the `nvx` command (remove it and no trace is left) ---
ln -sf "$NVX_HOME/bin/nvx" "$HOST_BIN/nvx"
info "Command 'nvx' -> $HOST_BIN/nvx (the only trace on your machine)"

# 7) Pre-install plugins + core LSP (treesitter parsers built via Lazy) ------
info "Loading Neovim plugins + core LSP (one-time, takes a moment)..."
nvim --headless "+Lazy! install" +qa || true
nvim --headless "+Lazy! restore" +qa || true
nvim --headless "+MasonInstall lua-language-server stylua" +qa || true

info "Done! Sandbox: $NVX_HOME"
info "Use: 'nvx' (open Neovim) · 'nvx add go' · 'nvx add-tool java@25 maven@3.9.6'"
info "Wipe everything: 'nvx uninstall'"
command -v nvx >/dev/null 2>&1 || warn "Add $HOST_BIN to PATH to call 'nvx' (or run $HOST_BIN/nvx)."
