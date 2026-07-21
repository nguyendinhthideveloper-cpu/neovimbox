# SPDX-License-Identifier: Apache-2.0
# Copyright 2026 thind
# Convenience targets (mirror CI). Recipes use '>' instead of tabs.
.RECIPEPREFIX = >
.PHONY: help lint fmt

help:
> @echo "make lint  — shellcheck install.sh nvx + stylua --check + luacheck"
> @echo "make fmt   — format nvim/ with stylua"

lint:
> shellcheck install.sh nvx
> stylua --check nvim/
> luacheck nvim/

fmt:
> stylua nvim/
