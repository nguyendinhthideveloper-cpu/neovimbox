<!-- SPDX-License-Identifier: Apache-2.0 -->
<!-- Copyright 2026 thind -->

# Keybindings

`<leader>` is <kbd>Space</kbd>. Press it and wait — [which-key](https://github.com/folke/which-key.nvim)
pops up the available groups. Most LSP keys (`gd`, `gr`, `K`, …) only bind once a
language server has attached to the buffer (`:LspInfo` to check).

> Tip: in Neovim you can always run `:NvxHelp` (or `<leader>?`) for a quick
> in-editor cheatsheet.

## Groups at a glance

| Prefix | Group |
|---|---|
| `<leader>f` | find / format |
| `<leader>c` | code |
| `<leader>r` | rename |
| `<leader>h` | git hunk |
| `<leader>g` | git (neogit / diff / graph) |
| `<leader>b` | buffer |
| `<leader>d` | debug |
| `<leader>t` | terminal / test |
| `<leader>x` | diagnostics (trouble) |
| `<leader>m` | harpoon (marks) |
| `<leader>a` | AI (codecompanion) |
| `<leader>s` | session |
| `<leader>o` | outline |

## Core editing

| Key | Mode | Action |
|---|---|---|
| `<leader>w` | n | Save file |
| `<leader>q` | n | Close window |
| `<Esc>` | n | Clear search highlight |
| `<C-h>` / `<C-j>` / `<C-k>` / `<C-l>` | n | Move to left / lower / upper / right split |
| `<` / `>` | v | Indent, keep selection |
| `J` / `K` | v | Move selected lines down / up |

## Find & format (Telescope, conform)

| Key | Action |
|---|---|
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep contents (needs ripgrep) |
| `<leader>fb` | Buffer list |
| `<leader>fr` | Recent files |
| `<leader>fh` | Help tags |
| `<leader>ft` | Find TODO comments |
| `<leader>fR` | Find & replace project-wide (grug-far) |
| `<leader>cf` | Format buffer (conform) |

## LSP / code (active when a server is attached)

| Key | Action |
|---|---|
| `gd` | Go to definition |
| `gr` | References |
| `gI` | Implementation |
| `K` | Hover documentation |
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Code action |
| `<leader>f` | Format buffer |
| `[d` / `]d` | Previous / next diagnostic |
| `<leader>o` | Outline (symbol panel) |

> This config navigates via LSP, **not** ctags. Use `gd`, not `<C-]>`
> (the latter reports `E433: No tags file` because there is no tags file).

## Git

### Hunks (gitsigns)

| Key | Action |
|---|---|
| `]c` / `[c` | Next / previous hunk |
| `<leader>hs` | Stage hunk |
| `<leader>hr` | Reset hunk |
| `<leader>hp` | Preview hunk |
| `<leader>hb` | Blame line (full) |

### UI (neogit / diffview / gitgraph)

| Key | Action |
|---|---|
| `<leader>gg` | Neogit — stage / commit / push / pull |
| `<leader>gd` | Diff view |
| `<leader>gh` | File history (current file) |
| `<leader>gl` | Git graph (commit tree); `<cr>` on a commit shows its diff |

## Buffers (bufferline)

| Key | Action |
|---|---|
| `[b` / `]b` | Previous / next buffer |
| `<leader>bd` | Close buffer |
| `<leader>bp` | Pin buffer |

## Navigation (flash, harpoon, nvim-tree)

| Key | Mode | Action |
|---|---|---|
| `s` | n/x/o | Flash jump (type 2 target chars) |
| `S` | n/x/o | Flash treesitter jump |
| `r` | o | Remote flash (operator-pending) |
| `<leader>e` | n | Toggle file explorer (nvim-tree) |
| `<C-h>` | n | Move focus into the file tree (left split) |
| `<leader>ma` | n | Harpoon: pin current file |
| `<C-e>` | n | Harpoon: quick menu |
| `<leader>m1`..`m4` | n | Harpoon: jump to pinned file 1–4 |

Inside nvim-tree: `<cr>` open, `a` create, `d` delete, `r` rename, `?` full help.

## Folding (ufo)

| Key | Action |
|---|---|
| `zR` | Open all folds |
| `zM` | Close all folds |
| `zK` | Peek folded lines under cursor |

## Terminal (toggleterm)

| Key | Mode | Action |
|---|---|---|
| `<C-\>` | n / t | Toggle floating terminal |
| `<leader>tf` | n | Terminal (float) |
| `<leader>th` | n | Terminal (horizontal) |

## Debug (nvim-dap)

| Key | Action |
|---|---|
| `<F5>` | Continue / start |
| `<F10>` | Step over |
| `<F11>` | Step into |
| `<F12>` | Step out |
| `<leader>db` | Toggle breakpoint |
| `<leader>dr` | Open REPL |
| `<leader>du` | Toggle debug UI |

## Test (neotest)

| Key | Action |
|---|---|
| `<leader>tt` | Test nearest function |
| `<leader>tr` | Test whole file |
| `<leader>td` | Debug nearest function |
| `<leader>ts` | Toggle summary panel |
| `<leader>to` | View output |
| `<leader>tw` | Toggle watch |

## Diagnostics (trouble)

| Key | Action |
|---|---|
| `<leader>xx` | Diagnostics (whole project) |
| `<leader>xX` | Diagnostics (current buffer) |
| `<leader>xs` | Symbols |
| `<leader>xq` | Quickfix list |
| `<leader>xl` | Location list |
| `<leader>xt` | TODO list |

## AI (codecompanion)

| Key | Mode | Action |
|---|---|---|
| `<leader>ac` | n / v | Toggle AI chat |
| `<leader>aa` | n / v | AI actions palette |
| `<leader>ai` | n / v | Inline edit (type a request) |

See [ai.md](ai.md) for setup and prompt examples.

## Session & database

| Key | Action |
|---|---|
| `<leader>ss` | Save session |
| `<leader>sr` | Restore session |
| `<leader>D` | Toggle database UI (dadbod) |

## Help

| Key | Action |
|---|---|
| `<leader>?` | Open the in-editor cheatsheet (`:NvxHelp`) |
| `<leader>` (then wait) | which-key group hints |
