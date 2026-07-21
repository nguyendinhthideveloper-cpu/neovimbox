<!-- SPDX-License-Identifier: Apache-2.0 -->
<!-- Copyright 2026 thind -->

# Troubleshooting

Quick fixes for the things people hit most often. When in doubt, run
`:checkhealth` and `:LspInfo`.

## `jdtls is not installed (run :MasonInstall jdtls)`

**Cause.** You opened a `.java` file before the `jdtls` Mason package finished
downloading. `mason-tools` installs it in the background on first start; `jdtls`
is large, so the first Java file can win the race.

**Fix.**

1. `:MasonInstall jdtls` (watch progress in `:Mason`).
2. When it finishes, **reopen the Java file** — `:e` — because an already-open
   buffer won't retry the server start.
3. Confirm with `:LspInfo`; you should see `jdtls` attached.

This is a first-run hiccup; later startups auto-install and the warning won't
return (as long as a JDK is on `PATH`). See [tools.md](tools.md#java-specifics).

## `E433: No tags file` / `E426: Tag not found`

**Cause.** You pressed `<C-]>` (Vim's built-in "jump to tag"). This config
navigates with **LSP, not ctags**, so there is no tags file.

**Fix.** Use the LSP keys instead:

| Instead of | Use |
|---|---|
| `<C-]>` | `gd` (go to definition) |
| `g<C-]>` | `gr` (references) |

If `gd` does nothing, the language server isn't attached yet — check `:LspInfo`
(for Java, see the `jdtls` section above).

## Cursor is stuck in a file — how do I get to the file tree?

The tree (nvim-tree) is the **left split**. Move focus with the window keys:

- `<C-h>` → jump into the tree (left)
- `<C-l>` → jump back to the file (right)

`<leader>e` **toggles** the tree open/closed (it doesn't just move focus), so when
the tree is already open, use `<C-h>` to focus it.

## Icons show as boxes / question marks

Icons need a [Nerd Font](https://www.nerdfonts.com). `install.sh` installs
JetBrainsMono Nerd Font and, on WSL, sets it as the Windows Terminal font.

- Restart the terminal after install so it picks up the font.
- On other terminals, select **JetBrainsMono Nerd Font** yourself.
- No Nerd Font available? Run with `NVX_NERD_FONT=0` for a plain-text fallback.

## AI (CodeCompanion) does nothing / errors on call

It needs `ANTHROPIC_API_KEY` in the environment **before** Neovim starts. Export
it in your shell (or via `nvx`), then reopen. See [ai.md](ai.md).

## Clipboard doesn't reach my host machine

Sandboxes have no X clipboard. This config uses **OSC52** (see
[`options.lua`](../nvim/lua/config/options.lua)) to push yanks to the host over
the terminal. Your terminal must support OSC52 (most modern ones do). Yank with
`y`; paste on the host with the host's normal paste.

## Plugins look broken after an update

- `:Lazy sync` to reconcile plugins with the lockfile.
- `:Lazy restore` to pin back to [`lazy-lock.json`](../nvim/lazy-lock.json).
- `:checkhealth` to see what a plugin reports missing.

## Still stuck?

Ask the built-in AI: `<leader>ac`, paste the error, and describe what you did.
See [ai.md](ai.md) for effective prompts.
