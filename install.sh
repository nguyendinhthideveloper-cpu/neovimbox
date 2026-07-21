#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0
# Copyright 2026 thind
# ============================================================================
# install.sh — build a NATIVE Neovim IDE (Neovim + mise), packaged in ONE sandbox.
# No Docker, nothing touches your machine: everything lives under $NVX_HOME
# (default ~/.nvx) by pointing XDG_*/MISE_* there. The host gets a SINGLE symlink,
# the `nvx` command.
#
# Wipe everything (Neovim included): `nvx uninstall`  ->  deletes exactly $NVX_HOME.
#
# After install:
#   nvx                       open Neovim (in the sandbox)
#   nvx add go                add a language
#   nvx add-tool java@25 maven@3.9.6 docker-cli    add any version/tool
#   nvx list | nvx update | nvx uninstall
#
# Move machines: git clone repo + ./install.sh (rebuilds an identical sandbox).
# ============================================================================
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NVX_HOME="${NVX_HOME:-$HOME/.nvx}"
HOST_BIN="$HOME/.local/bin"

info() { printf '\033[32m▸ %s\033[0m\n' "$*"; }
warn() { printf '\033[33m⚠ %s\033[0m\n' "$*" >&2; }

# 0) Prerequisites (can't auto-install — need root / differ per OS) -----------
miss=0
need() { command -v "$1" >/dev/null 2>&1 || { warn "missing '$1' — $2"; miss=1; }; }
need curl  "apt install curl / brew install curl"
need git   "apt install git / xcode-select --install"
need unzip "apt install unzip / brew install unzip (mason needs it)"
if ! command -v cc >/dev/null 2>&1 && ! command -v gcc >/dev/null 2>&1 && ! command -v clang >/dev/null 2>&1; then
  warn "missing C compiler (cc/gcc/clang) — needed for treesitter/rust-link/cgo/cpp"
  warn "  Ubuntu: sudo apt install build-essential   |   macOS: xcode-select --install"
  miss=1
fi
[ "$miss" -eq 0 ] || warn "Missing prerequisites above — continuing, but related parts may fail."

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

# 5) Copy Neovim config + command into the sandbox (self-contained; repo can be deleted after) ---
rm -rf "$NVX_HOME/config/nvim"
cp -r "$REPO_DIR/nvim" "$NVX_HOME/config/nvim"
cp "$REPO_DIR/nvx" "$NVX_HOME/bin/nvx"
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
