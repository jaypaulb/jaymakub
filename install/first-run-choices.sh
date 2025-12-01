#!/bin/bash

echo "[first-run-choices.sh] Starting user selection process..."

# Exit on Ctrl+C
trap 'echo -e "\n\n[first-run-choices.sh] Installation cancelled by user. Exiting..."; exit 130' INT

# Ask about HAL restore (optional - for restoring SSH/GPG keys and configs from backup server)
echo "[first-run-choices.sh] Prompting for HAL restore..."
export OMAKUB_HAL_RESTORE=$(gum confirm "Restore SSH/GPG keys and configs from HAL backup server?" && echo "yes" || echo "no")
[ $? -eq 130 ] && exit 130  # Exit if user pressed Ctrl+C
echo "[first-run-choices.sh] HAL restore: $OMAKUB_HAL_RESTORE"

# Terminal CLI Apps - defaults preselected
echo "[first-run-choices.sh] Prompting for terminal CLI apps..."
AVAILABLE_TERMINAL_APPS=("Agent-OS" "Azure CLI" "Btop" "Claude CLI" "Docker" "Fastfetch" "Gemini CLI" "Geekbench" "GitHub CLI" "GitLab CLI" "LazyDocker" "LazyGit" "Neovim" "Ollama" "Salesforce CLI" "Tailscale" "Zellij")
SELECTED_TERMINAL_APPS="Agent-OS,Azure CLI,Btop,Claude CLI,Fastfetch,Gemini CLI,GitHub CLI,GitLab CLI,LazyDocker,LazyGit,Neovim,Salesforce CLI,Zellij"
export OMAKUB_FIRST_RUN_TERMINAL_APPS=$(gum choose "${AVAILABLE_TERMINAL_APPS[@]}" --no-limit --selected "$SELECTED_TERMINAL_APPS" --height 18 --header "Select terminal CLI apps (defaults preselected)")
[ $? -eq 130 ] && exit 130  # Exit if user pressed Ctrl+C
echo "[first-run-choices.sh] Selected terminal apps: $OMAKUB_FIRST_RUN_TERMINAL_APPS"

# Only ask for desktop app choices when running Gnome
if [[ "$XDG_CURRENT_DESKTOP" == *"GNOME"* ]]; then
  echo "[first-run-choices.sh] Prompting for desktop apps..."
  # Desktop Apps - defaults preselected
  AVAILABLE_DESKTOP_APPS=("1password" "Alacritty" "ASDControl" "Audacity" "Bitwarden" "Brave" "Chrome" "Cursor" "Discord" "Doom Emacs" "Dropbox" "Flameshot" "GIMP" "Gnome Sushi" "Gnome Tweaks" "Helium" "LibreOffice" "LocalSend" "Logseq" "Mainline Kernels" "Minecraft" "OBS Studio" "Obsidian" "OnlyOffice" "Pinta" "RetroArch" "RubyMine" "Signal" "Spotify" "Steam" "Synergy" "Typora" "VirtualBox" "VLC" "VSCode" "Web Apps" "Windows" "Windsurf" "Xournal++" "Zed" "Zoom")
  SELECTED_DESKTOP_APPS="Alacritty,Bitwarden,Chrome,Cursor,Flameshot,Gnome Sushi,Gnome Tweaks,Helium,LocalSend,Logseq,OBS Studio,OnlyOffice,Pinta,Synergy,Typora,VLC,Xournal++,Zed"
  export OMAKUB_FIRST_RUN_DESKTOP_APPS=$(gum choose "${AVAILABLE_DESKTOP_APPS[@]}" --no-limit --selected "$SELECTED_DESKTOP_APPS" --height 25 --header "Select desktop apps (defaults preselected)")
  [ $? -eq 130 ] && exit 130  # Exit if user pressed Ctrl+C
  echo "[first-run-choices.sh] Selected desktop apps: $OMAKUB_FIRST_RUN_DESKTOP_APPS"
else
  echo "[first-run-choices.sh] Skipping desktop apps (not GNOME)"
fi

# Languages - C++ and Flutter added, new defaults
echo "[first-run-choices.sh] Prompting for programming languages..."
AVAILABLE_LANGUAGES=("Node.js" "Go" "Python" "Java" "C++" "Flutter" "Ruby on Rails" "PHP" "Elixir" "Rust")
SELECTED_LANGUAGES="Node.js,Go,Python,Java,C++,Flutter"
export OMAKUB_FIRST_RUN_LANGUAGES=$(gum choose "${AVAILABLE_LANGUAGES[@]}" --no-limit --selected "$SELECTED_LANGUAGES" --height 12 --header "Select programming languages (defaults preselected)")
[ $? -eq 130 ] && exit 130  # Exit if user pressed Ctrl+C
echo "[first-run-choices.sh] Selected languages: $OMAKUB_FIRST_RUN_LANGUAGES"

# Databases - none selected by default
echo "[first-run-choices.sh] Prompting for databases..."
AVAILABLE_DBS=("MySQL" "Redis" "PostgreSQL")
export OMAKUB_FIRST_RUN_DBS=$(gum choose "${AVAILABLE_DBS[@]}" --no-limit --height 5 --header "Select databases (runs in Docker, none by default)")
[ $? -eq 130 ] && exit 130  # Exit if user pressed Ctrl+C
echo "[first-run-choices.sh] Selected databases: $OMAKUB_FIRST_RUN_DBS"

echo "[first-run-choices.sh] ✓ User selections complete"
