# Security Policy

## Supported versions

| Version | Supported |
|---|---|
| latest release + `main` | ✅ |
| older | ❌ |

neovimbox is pre-1.0, so only the latest release and `main` receive fixes.

## Reporting a vulnerability

**Please do not open a public issue for security problems.** Instead, either:

- Use GitHub's private reporting: repo **Security → Report a vulnerability**, or
- Email the maintainer: **nguyen.dinh.thi.developer@gmail.com**

You'll get an acknowledgement as soon as possible, and a fix or mitigation plan
will be agreed before any public disclosure. Please include steps to reproduce
and the output of `nvx doctor` / `nvx version`.

Note: `nvx` installs toolchains from upstreams (mise/aqua, language runtimes,
mason). Vulnerabilities in those tools should be reported to their own projects.
