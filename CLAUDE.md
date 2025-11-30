# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Jaymakub is a customized fork of Omakub - a single-command system to transform a fresh Ubuntu 24.04+ installation into a fully-configured web development environment with GNOME desktop. It includes integrated HAL backup restoration and custom app selections.

## Key Commands

**Installation (fresh Ubuntu):**
```bash
wget -qO- https://raw.githubusercontent.com/jaypaulb/jaymakub/master/boot.sh | bash
```

**Post-install management via TUI menu:**
```bash
omakub              # Opens interactive menu
omakub theme        # Change theme directly
omakub font         # Change font directly
omakub update       # Update applications
omakub install      # Install optional apps (includes HAL Restore)
omakub uninstall    # Remove applications
```

## Architecture

### Entry Points
- `boot.sh` - Initial bootstrap that clones repo from github.com/jaypaulb/jaymakub
- `install.sh` - Main installer with optional HAL restore phase
- `install/hal-restore.sh` - Restores SSH/GPG keys and configs from HAL (192.168.1.4)
- `bin/omakub` - Post-install TUI menu (requires `$OMAKUB_PATH` env var)

### Directory Structure
- `install/terminal/` - Terminal tool installers (run in alphabetical order)
- `install/terminal/required/` - Required terminal dependencies
- `install/terminal/optional/` - Optional terminal apps (ollama, tailscale, geekbench)
- `install/desktop/` - Desktop app installers (defaults: Bitwarden, Cursor, OnlyOffice, Helium, Chrome, Alacritty)
- `install/desktop/optional/` - Optional desktop apps (VS Code, Signal, Obsidian, LibreOffice, Spotify, etc.)
- `install/hal-restore.sh` - HAL backup server restore script
- `bin/omakub-sub/` - TUI menu subcommands
- `themes/<name>/` - Theme configurations
- `configs/` - Application configs
- `defaults/bash/` - Shell configs
- `migrations/` - Timestamped migration scripts
- `uninstall/` - Uninstaller scripts for each app

### Default Apps (Auto-installed)

**Desktop:**
- Bitwarden (password manager)
- Cursor (AI code editor)
- OnlyOffice (office suite)
- Helium Browser
- Chrome, Alacritty, VLC, Pinta, Flameshot, LocalSend, ULauncher

**Terminal CLI Tools:**
- Claude Code CLI, Gemini CLI, Agent-OS
- GitLab CLI (glab), Salesforce CLI (sf), Azure CLI
- GitHub CLI (gh), lazygit, lazydocker, neovim, zellij, btop

**Default Languages:** Node.js, Go, Python, Java, C++, Flutter

**Databases:** None by default (MySQL, PostgreSQL, Redis available as optional)

### Optional Apps (via TUI menu)
VS Code, Signal, Obsidian, LibreOffice, 1password, Spotify, Zoom, Discord, Steam, etc.

### HAL Restore Feature
During install, prompts to restore from HAL backup server (192.168.1.4):
- SSH keys (with proper 600 permissions)
- GPG keys (with proper 700/600 permissions)
- Shell configs (.bashrc, .gitconfig, .aliases)
- App configs (.claude, .cursor, .vscode, .docker, .azure, .sf)

### Available Themes
Tokyo Night, Catppuccin, Nord, Everforest, Gruvbox, Kanagawa, Ristretto, Rose Pine, Matte Black, Osaka Jade

### Available Fonts
Cascadia Mono, Fira Mono, JetBrains Mono, Meslo (all Nerd Font variants)

## Shell Aliases (from defaults/bash/aliases)

Key aliases available after install:
- `ls` → `eza -lh` with icons
- `n` → `nvim` (opens current dir if no args)
- `g`, `d`, `r` → git, docker, rails
- `lzg`, `lzd` → lazygit, lazydocker
- `cd` → `z` (zoxide)
- `bat` → `batcat`
