# Jaymakub

**A customized fork of [Omakub](https://github.com/basecamp/omakub)** - Turn a fresh Ubuntu installation into a fully-configured, beautiful, and modern web development system by running a single command.

Jaymakub builds on the excellent foundation of Omakub with additional customizations and improvements tailored for Jay's development workflow.

## Installation

Run this single command on a fresh Ubuntu 24.04+ installation:

```bash
wget -qO- https://raw.githubusercontent.com/jaypaulb/jaymakub/master/boot.sh | bash
```

## About This Fork

Huge thanks to the [Basecamp team](https://github.com/basecamp/omakub) for creating Omakub! This fork adds:

### Key Enhancements

- **Interactive App Selection**: Separate selection screens for Terminal CLI apps and Desktop apps with defaults preselected (like the language selection)
- **Better UX**: Ctrl+C now properly exits the entire installation instead of proceeding to the next step
- **Dependency Ordering**: Smart install order ensures dependencies (Node.js, mise, etc.) are installed before apps that need them
- **Resilient Installation**: Individual installer failures don't crash the entire installation process
- **HAL Backup Integration**: Optional restore of SSH/GPG keys and configs from HAL backup server (192.168.1.4)

### Default Apps Included

**Terminal CLI Tools:**
- Claude Code CLI, Gemini CLI, Agent-OS
- GitHub CLI, GitLab CLI, Azure CLI, Salesforce CLI
- LazyGit, LazyDocker, Neovim, Zellij, Btop, Fastfetch

**Desktop Apps:**
- Bitwarden, Cursor, Chrome, Alacritty
- OnlyOffice, Logseq, Synergy
- VLC, Pinta, Flameshot, LocalSend, Helium

**Optional Apps Available:**
- Docker, Ollama, Tailscale, Geekbench (Terminal)
- VSCode, Obsidian, Signal, LibreOffice, Spotify, Discord, Steam, and many more (Desktop)

### Installation Flow

You'll see interactive selection screens for:
1. HAL Restore (SSH/GPG keys backup)
2. Terminal CLI Apps (17 available, 13 preselected)
3. Desktop Apps (40 available, 16 preselected)
4. Programming Languages (10 available, 6 preselected)
5. Databases (3 available, none preselected)

All selections show defaults preselected - just uncheck what you don't want!

## Original Omakub

Watch the introduction video and read more about the original Omakub at [omakub.org](https://omakub.org).

## Contributing to the documentation

Please help us improve Omakub's documentation on the [basecamp/omakub-site repository](https://github.com/basecamp/omakub-site).

## License

Omakub is released under the [MIT License](https://opensource.org/licenses/MIT).

## Extras

While omakub is purposed to be an opinionated take, the open source community offers alternative customization, add-ons, extras, that you can use to adjust, replace or enrich your experience.

[⇒ Browse the omakub extensions.](EXTENSIONS.md)
