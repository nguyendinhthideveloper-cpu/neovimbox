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

# 6.5) Nerd Font on the host so icons render (opt out with NVX_NO_FONT=1) -----
# This is the ONE thing that touches the host outside $NVX_HOME + the symlink;
# it is best-effort and never fails the install. Remove the copied .ttf files to
# undo. On WSL the font is installed into Windows; you still pick it in Windows
# Terminal manually.
install_font() {
  [ "${NVX_NO_FONT:-0}" = "1" ] && { info "Skipping Nerd Font install (NVX_NO_FONT=1)."; return 0; }
  local os; os="$(uname -s 2>/dev/null || echo unknown)"
  # already installed? (Linux/macOS check via fontconfig)
  if command -v fc-list >/dev/null 2>&1 && fc-list 2>/dev/null | grep -qi "JetBrainsMono Nerd Font"; then
    info "JetBrainsMono Nerd Font already installed."; return 0
  fi
  command -v unzip >/dev/null 2>&1 || { warn "Font install needs 'unzip' — skipping."; return 0; }
  local url="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
  local tmp; tmp="$(mktemp -d)"
  info "Downloading JetBrainsMono Nerd Font..."
  if ! curl -fL "$url" -o "$tmp/font.zip"; then
    warn "Font download failed — install a Nerd Font manually for icons."; rm -rf "$tmp"; return 0
  fi
  unzip -qo "$tmp/font.zip" -d "$tmp/f" >/dev/null 2>&1 || { warn "Font unzip failed."; rm -rf "$tmp"; return 0; }
  # collect .ttf files regardless of the archive's internal layout
  local ttfs; ttfs="$(find "$tmp/f" -type f -iname '*.ttf' 2>/dev/null)"
  [ -n "$ttfs" ] || { warn "No .ttf files in the font archive — skipping."; rm -rf "$tmp"; return 0; }

  if grep -qiE 'microsoft|wsl' /proc/version 2>/dev/null; then
    # WSL -> install per-user on Windows via PowerShell. We read %LOCALAPPDATA%
    # INSIDE PowerShell (not via cmd.exe, whose UNC-cwd warning corrupts it) and
    # register in HKCU, so no admin is needed and no manual step to copy files.
    local n=0
    if command -v powershell.exe >/dev/null 2>&1 && command -v wslpath >/dev/null 2>&1; then
      cat > "$tmp/inst.ps1" <<'PS'
param([string]$Src)
$dst = Join-Path $env:LOCALAPPDATA "Microsoft\Windows\Fonts"
$reg = "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Fonts"
New-Item -ItemType Directory -Force -Path $dst | Out-Null
$n = 0
Get-ChildItem -Path $Src -Recurse -Filter *.ttf | ForEach-Object {
  $t = Join-Path $dst $_.Name
  Copy-Item $_.FullName $t -Force
  New-ItemProperty -Path $reg -Name ($_.BaseName + " (TrueType)") -Value $t -PropertyType String -Force | Out-Null
  $n++
}
Write-Output ("NVXFONTS=" + $n)
PS
      local out
      out="$(powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$(wslpath -w "$tmp/inst.ps1")" -Src "$(wslpath -w "$tmp/f")" 2>/dev/null | tr -d '\r')"
      n="$(printf '%s\n' "$out" | sed -n 's/^NVXFONTS=//p')"; n="${n//[^0-9]/}"; [ -n "$n" ] || n=0
    fi
    if [ "$n" -gt 0 ]; then
      info "Installed $n font file(s) into Windows (per-user)."
      warn "WSL: restart Windows Terminal, then set Font face to 'JetBrainsMono Nerd Font' (Settings → your profile → Appearance)."
    else
      # interop unavailable — stage the fonts so the user can install them
      local stage="$NVX_HOME/fonts"; mkdir -p "$stage"
      while IFS= read -r f; do [ -n "$f" ] && cp -f "$f" "$stage/" 2>/dev/null; done <<EOF
$ttfs
EOF
      warn "Windows interop unavailable — fonts staged at: $stage"
      warn "Install them: explorer.exe \"\$(wslpath -w '$stage')\"  → select all → right-click → Install."
    fi
  elif [ "$os" = "Darwin" ]; then
    mkdir -p "$HOME/Library/Fonts"
    while IFS= read -r f; do [ -n "$f" ] && cp -f "$f" "$HOME/Library/Fonts/" 2>/dev/null; done <<EOF
$ttfs
EOF
    info "Installed to ~/Library/Fonts — select 'JetBrainsMono Nerd Font' in your terminal."
  else
    mkdir -p "$HOME/.local/share/fonts"
    while IFS= read -r f; do [ -n "$f" ] && cp -f "$f" "$HOME/.local/share/fonts/" 2>/dev/null; done <<EOF
$ttfs
EOF
    command -v fc-cache >/dev/null 2>&1 && fc-cache -f "$HOME/.local/share/fonts" >/dev/null 2>&1 || true
    info "Installed to ~/.local/share/fonts — select 'JetBrainsMono Nerd Font' in your terminal."
  fi
  rm -rf "$tmp"
}
install_font || warn "Font install skipped (error) — icons need a Nerd Font."

# 7) Pre-install plugins + core LSP (treesitter parsers built via Lazy) ------
info "Loading Neovim plugins + core LSP (one-time, takes a moment)..."
nvim --headless "+Lazy! install" +qa || true
nvim --headless "+Lazy! restore" +qa || true
nvim --headless "+MasonInstall lua-language-server stylua" +qa || true

info "Done! Sandbox: $NVX_HOME"
info "Use: 'nvx' (open Neovim) · 'nvx add go' · 'nvx add-tool java@25 maven@3.9.6'"
info "For icons, set your terminal font to 'JetBrainsMono Nerd Font' (installed above)."
info "Wipe everything: 'nvx uninstall'"
command -v nvx >/dev/null 2>&1 || warn "Add $HOST_BIN to PATH to call 'nvx' (or run $HOST_BIN/nvx)."
