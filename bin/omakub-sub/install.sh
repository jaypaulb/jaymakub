#!/bin/bash

CHOICES=(
  "Dev Editor        Install alternative programming editors"
  "Dev Language      Install programming language environment"
  "Dev Database      Install development database in Docker"
  "HAL Restore       Restore SSH/GPG keys and configs from HAL backup"
  "1password         Manage your passwords securely across devices"
  "Audacity          Record and edit audio"
  "ASDControl        Set brightness on Apple Studio and XDR displays"
  "Brave             Chrome-based browser with built-in ad blocking"
  "Discord           Communication platform for voice, video, and text messaging"
  "Dropbox           Sync files across computers with ease"
  "Geekbench         CPU benchmaking tool"
  "Gimp              Image manipulation tool ala Photoshop"
  "LibreOffice       Traditional office suite"
  "Mainline Kernels  Install newer Linux kernels than Ubuntu defaults"
  "Minecraft         Everyone's favorite blocky building game"
  "OBS Studio        Record screencasts with inputs from both display + webcam"
  "Obsidian          Markdown-based note taking application"
  "Ollama            Run LLMs, like Meta's Llama3, locally"
  "Retroarch         Play retro games"
  "Signal            Encrypted messaging application"
  "Spotify           Stream music from the world's most popular service"
  "Steam             Play games from Valve's store"
  "Tailscale         Mesh VPN based on WireGuard and with Magic DNS"
  "VirtualBox        Virtual machines to run Windows/Linux"
  "VSCode            Microsoft's popular code editor"
  "Web Apps          Install web apps with their own icon and shell"
  "Zoom              Attend and host video chat meetings"
  "> All             Re-run any of the default installers"
  "<< Back           "
)

CHOICE=$(gum choose "${CHOICES[@]}" --height 26 --header "Install application")

if [[ "$CHOICE" == "<< Back"* ]] || [[ -z "$CHOICE" ]]; then
  # Don't install anything
  echo ""
elif [[ "$CHOICE" == "> All"* ]]; then
  INSTALLER_FILE=$(gum file $OMAKUB_PATH/install)

  [[ -n "$INSTALLER_FILE" ]] &&
    gum confirm "Run installer?" &&
    source $INSTALLER_FILE &&
    gum spin --spinner globe --title "Install completed!" -- sleep 3
else
  INSTALLER=$(echo "$CHOICE" | awk -F ' {2,}' '{print $1}' | tr '[:upper:]' '[:lower:]' | sed 's/ /-/g')

  case "$INSTALLER" in
  "dev-editor") INSTALLER_FILE="$OMAKUB_PATH/bin/omakub-sub/install-dev-editor.sh" ;;
  "web-apps") INSTALLER_FILE="$OMAKUB_PATH/install/desktop/optional/select-web-apps.sh" ;;
  "dev-language") INSTALLER_FILE="$OMAKUB_PATH/install/terminal/select-dev-language.sh" ;;
  "dev-database") INSTALLER_FILE="$OMAKUB_PATH/install/terminal/select-dev-storage.sh" ;;
  "hal-restore") INSTALLER_FILE="$OMAKUB_PATH/install/hal-restore.sh"; export OMAKUB_HAL_RESTORE="yes" ;;
  "ollama") INSTALLER_FILE="$OMAKUB_PATH/install/terminal/optional/app-ollama.sh" ;;
  "tailscale") INSTALLER_FILE="$OMAKUB_PATH/install/terminal/optional/app-tailscale.sh" ;;
  "geekbench") INSTALLER_FILE="$OMAKUB_PATH/install/terminal/optional/app-geekbench.sh" ;;
  "vscode") INSTALLER_FILE="$OMAKUB_PATH/install/desktop/optional/app-vscode.sh" ;;
  "signal") INSTALLER_FILE="$OMAKUB_PATH/install/desktop/optional/app-signal.sh" ;;
  "obsidian") INSTALLER_FILE="$OMAKUB_PATH/install/desktop/optional/app-obsidian.sh" ;;
  "libreoffice") INSTALLER_FILE="$OMAKUB_PATH/install/desktop/optional/app-libreoffice.sh" ;;
  *) INSTALLER_FILE="$OMAKUB_PATH/install/desktop/optional/app-$INSTALLER.sh" ;;
  esac

  source $INSTALLER_FILE && gum spin --spinner globe --title "Install completed!" -- sleep 3
fi

clear
source $OMAKUB_PATH/bin/omakub
