#!/bin/bash

# Ask about HAL restore (optional - for restoring SSH/GPG keys and configs from backup server)
export OMAKUB_HAL_RESTORE=$(gum confirm "Restore SSH/GPG keys and configs from HAL backup server?" && echo "yes" || echo "no")

# Only ask for default desktop app choices when running Gnome
if [[ "$XDG_CURRENT_DESKTOP" == *"GNOME"* ]]; then
  OPTIONAL_APPS=("1password" "Spotify" "Zoom" "Dropbox" "VSCode" "Signal" "Obsidian" "LibreOffice" "Audacity" "Brave" "Discord" "Steam" "VirtualBox")
  export OMAKUB_FIRST_RUN_OPTIONAL_APPS=$(gum choose "${OPTIONAL_APPS[@]}" --no-limit --height 15 --header "Select optional apps (none selected by default)" | tr ' ' '-')
fi

# Languages - C++ and Flutter added, new defaults
AVAILABLE_LANGUAGES=("Node.js" "Go" "Python" "Java" "C++" "Flutter" "Ruby on Rails" "PHP" "Elixir" "Rust")
SELECTED_LANGUAGES="Node.js,Go,Python,Java,C++,Flutter"
export OMAKUB_FIRST_RUN_LANGUAGES=$(gum choose "${AVAILABLE_LANGUAGES[@]}" --no-limit --selected "$SELECTED_LANGUAGES" --height 12 --header "Select programming languages")

# Databases - none selected by default
AVAILABLE_DBS=("MySQL" "Redis" "PostgreSQL")
export OMAKUB_FIRST_RUN_DBS=$(gum choose "${AVAILABLE_DBS[@]}" --no-limit --height 5 --header "Select databases (runs in Docker, none by default)")
