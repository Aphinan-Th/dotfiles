# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

macOS dotfiles repo. All configs live under `.config/` and are meant to be symlinked to `~/.config/`.

## Components

- **Neovim** (`.config/nvim/`) — LazyVim-based config. Entry point: `init.lua` → `config/lazy.lua`. Custom plugins in `lua/plugins/`, config overrides in `lua/config/` (keymaps, options, autocmds). LSP helpers in `lua/craftzdog/`.
- **AeroSpace** (`.config/aerospace/`) — Tiling window manager. Single `aerospace.toml` config. Launches SketchyBar and JankyBorders on startup. Notifies SketchyBar on workspace changes.
- **SketchyBar** (`.config/sketchybar/`) — Custom menu bar. `sketchybarrc` is the entry point, sources `colors.sh` for theming. Bar items defined in `items/`, event handlers and scripts in `plugins/`.
- **Karabiner** (`.config/karabiner/`) — Keyboard remapping. `karabiner.json` is the main config. Complex modifications stored as individual JSON files in `assets/complex_modifications/`.

## Neovim Details

- **Colorscheme**: Tokyo Night with transparent backgrounds (sidebars and floats).
- **Picker**: Telescope (set via `lazyvim_picker = "telescope"`), with fzf-native and file-browser extensions. File browser opens with `sf`.
- **Completion**: blink.cmp (set via `lazyvim_cmp = "blink.cmp"`).
- **Formatters** (conform.nvim): Prettier for web languages (JS/TS/CSS/HTML/JSON/YAML/Markdown), Stylua for Lua, shfmt for shell, Ruff for Python.
- **LSP servers** (Mason): tsserver, tailwindcss, cssls, lua_ls, pyright, ruff, html, yamlls. Python uses Pyright for type checking + Ruff native server for linting/formatting with auto-fix on save.
- **LazyVim extras enabled**: TypeScript, Rust, JSON, Markdown, Tailwind, eslint, prettier, mini-hipatterns.
- **Style**: 2-space indentation, no line wrapping, shell set to fish, spell checking enabled (en_us).
- **Key custom keymaps**: `<leader>r` for hex-to-HSL conversion, `<leader>i` for toggling inlay hints, `<leader>z` for Zen Mode, `<C-j>` for next diagnostic.

## Key Relationships

- AeroSpace and SketchyBar are tightly coupled: AeroSpace starts SketchyBar and sends workspace change events via `sketchybar --trigger`. The `plugins/aerospace_callback.sh` and `plugins/aerospace_events.sh` scripts handle these events.
- SketchyBar uses SF Pro font and a custom color scheme defined in `colors.sh` (currently a semi-transparent dark theme with white accent).
- AeroSpace also launches JankyBorders with a gradient active window border.
- Neovim plugin development path is set to `~/.ghq/github.com` (uses ghq for Git repo management).
- Neovim UI uses incline.nvim for floating filenames, styled with solarized-osaka colors (a craftzdog plugin dependency).
- AeroSpace uses workspaces 1, 2, 3, and S (secondary monitor), with alt as the primary modifier key.
