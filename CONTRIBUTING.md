# Contributing to neovimbox (`nvx`)

The project is a native Neovim IDE packaged in the `~/.nvx` sandbox. Only three parts:

| Path | Role |
|---|---|
| `install.sh` | Bootstrap: install mise → Neovim/Node/ripgrep/fd → nvim config into `~/.nvx`. |
| `nvx` | CLI: open Neovim + `add`/`add-tool`/`exec`/`shell`/`rm`/`list`/`update`/`uninstall`. Language installation lives in the `lang_add` function. |
| `nvim/` | Neovim config (lazy.nvim). `lua/plugins/*` = one file per plugin group. |

## Lint (matches CI `.github/workflows/ci.yml`)

```bash
shellcheck install.sh nvx          # shell (uses .shellcheckrc)
stylua --check nvim/               # format Lua (.stylua.toml)
luacheck nvim/                     # static Lua lint (.luacheckrc)
```
> Install tools quickly via mise: `mise use -g shellcheck stylua` (luacheck via `luarocks install luacheck`).

## Test

CI has a `smoke` job that runs `./install.sh` + `nvx add go` + `nvx add-tool yq` on a clean Ubuntu and checks that the sandbox does not scatter files onto the host. The local equivalent (best run in a container/VM to avoid touching your real machine):
```bash
./install.sh && nvx exec nvim --version && nvx add go && nvx exec go version
```

## Adding a new language

Add a `case` branch to the `lang_add` function in `nvx`: `mise use -g <runtime>` +
`mason <lsp> <formatter> <linter> <dap>`. Follow the corresponding Neovim configuration
(`nvim/lua/plugins/lsp.lua`, `mason-tools.lua`, `conform.lua`, `lint.lua`, `dap.lua`).

## Commit & release

- Use **Conventional Commits** (`feat:`, `fix:`, `refactor:`, `docs:`, `chore:`,
  `feat!:`/`BREAKING CHANGE:`...). release-please auto-builds the CHANGELOG + tags from them.
- Keep scripts at **LF** (enforced in `.gitattributes`) — CRLF breaks the shebang.
