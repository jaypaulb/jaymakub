#!/bin/bash

# Exit on Ctrl+C
trap 'echo -e "\n\nInstallation cancelled by user. Exiting..."; exit 130' INT

# Ask about HAL restore (optional - for restoring SSH/GPG keys and configs from backup server)
export OMAKUB_HAL_RESTORE=$(gum confirm "Restore SSH/GPG keys and configs from HAL backup server?" && echo "yes" || echo "no")
[ $? -eq 130 ] && exit 130  # Exit if user pressed Ctrl+C

# Terminal CLI Apps - defaults preselected
AVAILABLE_TERMINAL_APPS=("Agent-OS" "Azure CLI" "Btop" "Claude CLI" "Docker" "Fastfetch" "Gemini CLI" "Geekbench" "GitHub CLI" "GitLab CLI" "LazyDocker" "LazyGit" "Neovim" "Ollama" "Salesforce CLI" "Tailscale" "Zellij")
SELECTED_TERMINAL_APPS="Agent-OS,Azure CLI,Btop,Claude CLI,Fastfetch,Gemini CLI,GitHub CLI,GitLab CLI,LazyDocker,LazyGit,Neovim,Salesforce CLI,Zellij"
export OMAKUB_FIRST_RUN_TERMINAL_APPS=$(gum choose "${AVAILABLE_TERMINAL_APPS[@]}" --no-limit --selected "$SELECTED_TERMINAL_APPS" --height 18 --header "Select terminal CLI apps (defaults preselected)")
[ $? -eq 130 ] && exit 130  # Exit if user pressed Ctrl+C

# Only ask for desktop app choices when running Gnome
if [[ "$XDG_CURRENT_DESKTOP" == *"GNOME"* ]]; then
  # Desktop Apps - defaults preselected
  AVAILABLE_DESKTOP_APPS=("1password" "Alacritty" "ASDControl" "Audacity" "Bitwarden" "Brave" "Chrome" "Cursor" "Discord" "Doom Emacs" "Dropbox" "Flameshot" "GIMP" "Gnome Sushi" "Gnome Tweaks" "Helium" "LibreOffice" "LocalSend" "Logseq" "Mainline Kernels" "Minecraft" "OBS Studio" "Obsidian" "OnlyOffice" "Pinta" "RetroArch" "RubyMine" "Signal" "Spotify" "Steam" "Synergy" "Typora" "VirtualBox" "VLC" "VSCode" "Web Apps" "Windows" "Windsurf" "Xournal++" "Zed" "Zoom")
  SELECTED_DESKTOP_APPS="Alacritty,Bitwarden,Chrome,Cursor,Flameshot,Gnome Sushi,Gnome Tweaks,Helium,LocalSend,Logseq,OnlyOffice,Pinta,Synergy,Typora,VLC,Xournal++"
  export OMAKUB_FIRST_RUN_DESKTOP_APPS=$(gum choose "${AVAILABLE_DESKTOP_APPS[@]}" --no-limit --selected "$SELECTED_DESKTOP_APPS" --height 25 --header "Select desktop apps (defaults preselected)")
  [ $? -eq 130 ] && exit 130  # Exit if user pressed Ctrl+C
fi

# Languages - C++ and Flutter added, new defaults
AVAILABLE_LANGUAGES=("Node.js" "Go" "Python" "Java" "C++" "Flutter" "Ruby on Rails" "PHP" "Elixir" "Rust")
SELECTED_LANGUAGES="Node.js,Go,Python,Java,C++,Flutter"
export OMAKUB_FIRST_RUN_LANGUAGES=$(gum choose "${AVAILABLE_LANGUAGES[@]}" --no-limit --selected "$SELECTED_LANGUAGES" --height 12 --header "Select programming languages (defaults preselected)")
[ $? -eq 130 ] && exit 130  # Exit if user pressed Ctrl+C

# Databases - none selected by default
AVAILABLE_DBS=("MySQL" "Redis" "PostgreSQL")
export OMAKUB_FIRST_RUN_DBS=$(gum choose "${AVAILABLE_DBS[@]}" --no-limit --height 5 --header "Select databases (runs in Docker, none by default)")
[ $? -eq 130 ] && exit 130  # Exit if user pressed Ctrl+C
