<!-- SPDX-License-Identifier: Apache-2.0 -->
<!-- Copyright 2026 thind -->

# neovimbox docs

The wiki for [`nvx`](../README.md) — a Neovim-based multi-language IDE in a single
directory. Start here.

## Guides

| Doc | What's inside |
|---|---|
| [Keybindings](keybindings.md) | Full keymap reference, grouped by prefix |
| [Languages & tools](tools.md) | Adding languages, Mason, LSP/format/lint/DAP |
| [AI assistance](ai.md) | CodeCompanion setup, keys, prompt recipes |
| [Troubleshooting](troubleshooting.md) | Common errors and their fixes |
| [Roadmap](ROADMAP.md) | Where the project is headed |

## In-editor help

- Press `<leader>?` (or run `:NvxHelp`) inside Neovim for a quick cheatsheet.
- Press `<leader>` and wait for [which-key](https://github.com/folke/which-key.nvim)
  to show the available groups.
- `:checkhealth`, `:LspInfo`, `:Mason`, `:Lazy` for the underlying tooling.

## First steps

1. Install: see the [top-level README](../README.md#install).
2. Add a language: `nvx add go` (see [tools.md](tools.md)).
3. Open Neovim: `nvx`.
4. Learn the keys: [keybindings.md](keybindings.md) or `<leader>?`.
5. Optional — set `ANTHROPIC_API_KEY` for [AI help](ai.md).
