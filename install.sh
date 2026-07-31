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
HERE="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" 2>/dev/null && pwd)" || HERE=""

# ---------------------------------------------------------------------------
# Presentation layer — DELIBERATE DUPLICATION of the same block at the top of
# `nvx`. This script runs standalone (`curl | bash`) *before* nvx exists on
# disk, so it cannot source the definitions. Keep the two copies IN SYNC: same
# guards, same glyphs, same function names, so installer and command feel like
# one tool.
#
# Colour belongs to the STREAM, not the program: stdout and stderr are judged
# separately so `... | tee log` keeps the terminal readable while the piped copy
# stays plain. Honours NO_COLOR and TERM=dumb; FORCE_COLOR overrides detection.
# Glyphs drop to ASCII when the locale is not UTF-8 or NVX_NERD_FONT=0 (the same
# switch nvim/init.lua uses).
_color_ok() { # $1 = fd number
  [ -n "${NO_COLOR:-}" ] && return 1
  [ -n "${FORCE_COLOR:-}" ] && return 0
  [ "${TERM:-}" = "dumb" ] && return 1
  [ -t "$1" ]
}

# Palette per stream: stdout (info/ok/step/dim) and stderr (warn/err) are
# resolved independently — one can be a terminal while the other is a file.
if _color_ok 1; then
  C_STEP=$'\e[1;36m'; C_INFO=$'\e[32m'; C_OK=$'\e[32m'; C_DIM=$'\e[2m'; C_RST=$'\e[0m'
else
  C_STEP=''; C_INFO=''; C_OK=''; C_DIM=''; C_RST=''
fi
if _color_ok 2; then
  C_WARN=$'\e[33m'; C_ERR=$'\e[31m'; C_RST2=$'\e[0m'
else
  C_WARN=''; C_ERR=''; C_RST2=''
fi

# UTF-8 glyphs need a UTF-8 locale AND a user who wants them. An UNSET locale is
# treated as capable: CI runners usually have none and should keep pretty output.
_utf8_ok() {
  [ "${NVX_NERD_FONT:-1}" = "0" ] && return 1
  local loc="${LC_ALL:-${LC_CTYPE:-${LANG:-}}}"
  [ -z "$loc" ] && return 0
  case "$loc" in *[Uu][Tt][Ff]*) return 0 ;; *) return 1 ;; esac
}
# ASCII fallbacks are all single-width so columns still line up.
if _utf8_ok; then
  G_STEP='▸'; G_OK='✓'; G_WARN='⚠'; G_ERR='✗'
else
  G_STEP='>'; G_OK='+'; G_WARN='!'; G_ERR='x'
fi

# Step counter: set STEP_TOTAL>0 to get "[n/total]" headings (nvx leaves it 0 and
# gets plain headings). Text only, no spinner — a counter reads correctly in a
# terminal and in a CI log, and subprocess output stays visible underneath.
STEP_TOTAL="${STEP_TOTAL:-0}"; STEP_N=0
step() {
  STEP_N=$((STEP_N + 1))
  if [ "$STEP_TOTAL" -gt 0 ]; then
    printf '\n%s%s [%d/%d] %s%s\n' "$C_STEP" "$G_STEP" "$STEP_N" "$STEP_TOTAL" "$*" "$C_RST"
  else
    printf '\n%s%s %s%s\n' "$C_STEP" "$G_STEP" "$*" "$C_RST"
  fi
}
info() { printf '%s%s %s%s\n' "$C_INFO" "$G_STEP" "$*" "$C_RST"; }
ok()   { printf '%s%s %s%s\n' "$C_OK" "$G_OK" "$*" "$C_RST"; }
dim()  { printf '%s%s%s\n' "$C_DIM" "$*" "$C_RST"; }
warn() { printf '%s%s %s%s\n' "$C_WARN" "$G_WARN" "$*" "$C_RST2" >&2; }
# err/die: kept for parity with nvx. err only reports; die is the one that exits.
err()  { printf '%s%s %s%s\n' "$C_ERR" "$G_ERR" "$*" "$C_RST2" >&2; }
die()  { err "$*"; exit 1; }
# ---------------------------------------------------------------------------

STEP_TOTAL=8

# 0) Prerequisites (can't auto-install — need root / differ per OS) -----------
step "Checking prerequisites"
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
step "Fetching neovimbox"
if [ -n "$HERE" ] && [ -f "$HERE/nvx" ] && [ -d "$HERE/nvim" ]; then
  SRC="$HERE"
  info "Using the local checkout: $SRC"
else
  SRC="$NVX_HOME/src"
  info "Cloning $REPO_URL..."
  rm -rf "$SRC"; mkdir -p "$(dirname "$SRC")"
  git clone --depth 1 "$REPO_URL" "$SRC"
fi

# 1) Sandbox layout ----------------------------------------------------------
step "Creating the sandbox ($NVX_HOME)"
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
# The heading is printed unconditionally (outside the if) so the counter never
# skips a number when mise is already there from an earlier run.
step "Installing mise"
if [ ! -x "$NVX_HOME/bin/mise" ]; then
  info "Downloading mise into the sandbox..."
  curl -fsSL https://mise.run | MISE_INSTALL_PATH="$NVX_HOME/bin/mise" sh
else
  ok "mise already in the sandbox."
fi

# 4) Neovim + Node + ripgrep + fd (all in the sandbox) -----------------------
step "Installing Neovim, Node, ripgrep, fd"
mise use -g neovim@latest node@20 ripgrep fd
mise reshim; hash -r 2>/dev/null || true

# 5) Copy Neovim config + command into the sandbox (self-contained) ----------
step "Copying the config and the nvx command"
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
  local url="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
  local tmp; tmp="$(mktemp -d)"
  info "Downloading JetBrainsMono Nerd Font..."
  if ! curl -fL "$url" -o "$tmp/font.zip"; then
    warn "Font download failed — install a Nerd Font manually for icons."; rm -rf "$tmp"; return 0
  fi

  if grep -qiE 'microsoft|wsl' /proc/version 2>/dev/null \
     && command -v powershell.exe >/dev/null 2>&1 && command -v wslpath >/dev/null 2>&1; then
    # WSL: do it all in PowerShell — unzip (Expand-Archive, so no `unzip` needed),
    # install the font per-user (HKCU, no admin), and point Windows Terminal at it.
    # %LOCALAPPDATA% is read inside PowerShell to dodge the cmd.exe UNC-cwd warning.
    cat > "$tmp/nvxfont.ps1" <<'PS'
param([string]$Zip)
$work = Join-Path $env:TEMP ("nvxfont_" + [System.Guid]::NewGuid().ToString("N"))
New-Item -ItemType Directory -Force -Path $work | Out-Null
Expand-Archive -Path $Zip -DestinationPath $work -Force
$dst = Join-Path $env:LOCALAPPDATA "Microsoft\Windows\Fonts"
$reg = "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Fonts"
New-Item -ItemType Directory -Force -Path $dst | Out-Null
$n = 0
Get-ChildItem -Path $work -Recurse -Filter *.ttf | ForEach-Object {
  $t = Join-Path $dst $_.Name
  Copy-Item $_.FullName $t -Force
  New-ItemProperty -Path $reg -Name ($_.BaseName + " (TrueType)") -Value $t -PropertyType String -Force | Out-Null
  $n++
}
Remove-Item $work -Recurse -Force -ErrorAction SilentlyContinue
Write-Output ("NVXFONTS=" + $n)
# Point Windows Terminal at the font (backup settings.json to .nvxbak; skip on error)
$paths = @(
  (Join-Path $env:LOCALAPPDATA 'Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json'),
  (Join-Path $env:LOCALAPPDATA 'Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState\settings.json'),
  (Join-Path $env:LOCALAPPDATA 'Microsoft\Windows Terminal\settings.json')
)
$wt = 0
foreach ($p in $paths) {
  if (-not (Test-Path $p)) { continue }
  try {
    $raw = Get-Content -Raw -Path $p
    $clean = (($raw -replace "`r","") -split "`n" | Where-Object { $_ -notmatch '^\s*//' }) -join "`n"
    $j = $clean | ConvertFrom-Json
    if (-not $j.profiles) { $j | Add-Member -NotePropertyName profiles -NotePropertyValue ([pscustomobject]@{}) -Force }
    if (-not $j.profiles.defaults) { $j.profiles | Add-Member -NotePropertyName defaults -NotePropertyValue ([pscustomobject]@{}) -Force }
    if (-not $j.profiles.defaults.font) { $j.profiles.defaults | Add-Member -NotePropertyName font -NotePropertyValue ([pscustomobject]@{}) -Force }
    $j.profiles.defaults.font | Add-Member -NotePropertyName face -NotePropertyValue "JetBrainsMono Nerd Font" -Force
    Copy-Item $p "$p.nvxbak" -Force
    ($j | ConvertTo-Json -Depth 32) | Set-Content -Path $p -Encoding UTF8
    $wt++
  } catch { }
}
Write-Output ("NVXWT=" + $wt)
PS
    local out n wt
    out="$(powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$(wslpath -w "$tmp/nvxfont.ps1")" -Zip "$(wslpath -w "$tmp/font.zip")" 2>/dev/null | tr -d '\r')"
    n="$(printf '%s\n' "$out" | sed -n 's/^NVXFONTS=//p')"; n="${n//[^0-9]/}"; [ -n "$n" ] || n=0
    wt="$(printf '%s\n' "$out" | sed -n 's/^NVXWT=//p')"; wt="${wt//[^0-9]/}"; [ -n "$wt" ] || wt=0
    if [ "$n" -gt 0 ]; then
      info "Installed $n font file(s) into Windows (per-user)."
      if [ "$wt" -gt 0 ]; then
        info "Set Windows Terminal font automatically (backup: settings.json.nvxbak). Restart the terminal to apply."
      else
        warn "Font installed; set the terminal font once: Windows Terminal → Settings → your profile → Appearance → Font face → 'JetBrainsMono Nerd Font'."
      fi
    else
      warn "Font install produced no files — install a Nerd Font manually."
    fi
    rm -rf "$tmp"; return 0
  fi

  # Native Linux / macOS: extract with unzip and drop into the user font dir.
  if ! command -v unzip >/dev/null 2>&1; then
    warn "Font install needs 'unzip' — install it and re-run for icons."; rm -rf "$tmp"; return 0
  fi
  unzip -qo "$tmp/font.zip" -d "$tmp/f" >/dev/null 2>&1 || { warn "Font unzip failed."; rm -rf "$tmp"; return 0; }
  local ttfs; ttfs="$(find "$tmp/f" -type f -iname '*.ttf' 2>/dev/null)"
  [ -n "$ttfs" ] || { warn "No .ttf files in the font archive — skipping."; rm -rf "$tmp"; return 0; }
  local fdir="$HOME/.local/share/fonts"; [ "$os" = "Darwin" ] && fdir="$HOME/Library/Fonts"
  mkdir -p "$fdir"
  while IFS= read -r f; do [ -n "$f" ] && cp -f "$f" "$fdir/" 2>/dev/null; done <<EOF
$ttfs
EOF
  if [ "$os" != "Darwin" ] && command -v fc-cache >/dev/null 2>&1; then
    fc-cache -f "$fdir" >/dev/null 2>&1 || true
  fi
  info "Installed to $fdir — select 'JetBrainsMono Nerd Font' in your terminal."
  rm -rf "$tmp"
}
step "Installing JetBrainsMono Nerd Font"
install_font || warn "Font install skipped (error) — icons need a Nerd Font."

# 7) Pre-install plugins + core LSP (treesitter parsers built via Lazy) ------
# The longest step by far: say so up front, and let Lazy/Mason print underneath
# rather than hiding them behind a progress display — if one fails, the reason is
# already on screen instead of buried in a log we would have to dump.
step "Loading Neovim plugins and core LSP"
info "One-time, takes a few minutes on a slow network — output follows."
nvim --headless "+Lazy! install" +qa || true
nvim --headless "+Lazy! restore" +qa || true
nvim --headless "+MasonInstall lua-language-server stylua" +qa || true

# Closing block: one success heading, then quieter detail. The next command to
# run comes first; font/wipe notes are dimmed because they are reference, not
# instructions. The PATH check is last and loud — nvx is unusable until it passes.
printf '\n'
ok "Neovimbox is ready. Sandbox: $NVX_HOME"
printf '\n'
info "Run 'nvx' to open Neovim."
dim "    nvx add go                          add a language (go|python|rust|jvm|node|cpp)"
dim "    nvx add-tool java@25 maven@3.9.6    add CLI tools/versions"
printf '\n'
dim "    Icons: set your terminal font to 'JetBrainsMono Nerd Font' (installed above)."
dim "    Wipe everything: 'nvx uninstall' (deletes $NVX_HOME)."
if ! command -v nvx >/dev/null 2>&1; then
  printf '\n'
  warn "'nvx' is not on your PATH yet — add $HOST_BIN to PATH, or run $HOST_BIN/nvx directly."
fi
