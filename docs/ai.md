<!-- SPDX-License-Identifier: Apache-2.0 -->
<!-- Copyright 2026 thind -->

# AI assistance (CodeCompanion)

The editor ships with [CodeCompanion](https://github.com/olimorris/codecompanion.nvim),
wired to **Claude (Anthropic)** for chat and Cursor-style inline edits
([`ai.lua`](../nvim/lua/plugins/ai.lua)). Use it to explain code, generate
changes, write tests, or get unstuck — without leaving Neovim.

## Setup

CodeCompanion reads `ANTHROPIC_API_KEY` from the environment. With no key it stays
silent and only errors when you actually call it.

```bash
export ANTHROPIC_API_KEY="sk-ant-..."   # in your shell profile, then:
nvx                                      # open Neovim with the key in env
```

Set it **before** launching Neovim. Get a key from the
[Anthropic Console](https://console.anthropic.com/).

## Keys

| Key | Mode | What it does |
|---|---|---|
| `<leader>ac` | n / v | Toggle the **chat** window |
| `<leader>aa` | n / v | Open the **actions** palette (predefined workflows) |
| `<leader>ai` | n / v | **Inline** edit — type a request; the AI edits in place |

In visual mode, the selected text becomes context — select code first, then press
the key.

## Typical workflows

**Explain a function.** Visually select it → `<leader>ac` → ask
*"Explain what this does and note any edge cases."*

**Refactor in place.** Select code → `<leader>ai` → type
*"extract this into a helper and add early returns"* → the buffer is edited
directly.

**Generate tests.** Select a function → `<leader>aa` → pick a test action, or in
chat: *"Write table-driven tests for this, covering the empty and error cases."*

**Debug an error.** Copy the message from `:messages`, `<leader>ac`, paste it, and
describe what you ran. Great for the kinds of issues in
[troubleshooting.md](troubleshooting.md).

## Prompt tips

- **Give context.** Select the relevant code, or say which file/function.
- **Be specific about the output.** "return only the diff", "keep the existing
  style", "no comments".
- **Iterate in chat.** Follow up with "smaller", "now add error handling",
  "explain why" — the chat keeps the thread.
- **Verify.** Treat generated code as a draft: run it, run tests
  (`<leader>tt`), read the diff before committing.

## Privacy note

Inline/chat requests send the code you reference to Anthropic's API. Don't paste
secrets; keep `ANTHROPIC_API_KEY` out of the repo (use your shell env).
