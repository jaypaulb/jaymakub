#!/bin/bash

# Helper function to check if desktop app was selected
should_install_desktop_app() {
  local app_name=$1
  local display_name=""

  # Map filenames to display names
  case "$app_name" in
    *alacritty*) display_name="Alacritty" ;;
    *bitwarden*) display_name="Bitwarden" ;;
    *chrome*) display_name="Chrome" ;;
    *cursor*) display_name="Cursor" ;;
    *flameshot*) display_name="Flameshot" ;;
    *gnome-sushi*) display_name="Gnome Sushi" ;;
    *gnome-tweak*) display_name="Gnome Tweaks" ;;
    *helium*) display_name="Helium" ;;
    *localsend*) display_name="LocalSend" ;;
    *logseq*) display_name="Logseq" ;;
    *obs-studio*) display_name="OBS Studio" ;;
    *onlyoffice*) display_name="OnlyOffice" ;;
    *pinta*) display_name="Pinta" ;;
    *synergy*) display_name="Synergy" ;;
    *typora*) display_name="Typora" ;;
    *vlc*) display_name="VLC" ;;
    *xournalpp*) display_name="Xournal++" ;;
    *zed*) display_name="Zed" ;;
    *wl-clipboard*) return 0 ;; # Always install system utilities
    *) return 0 ;; # Install non-app installers (flatpak, fonts, etc.)
  esac

  # Check if app is in the selected list
  echo "$OMAKUB_FIRST_RUN_DESKTOP_APPS" | grep -q "$display_name"
}

# Helper function to check optional desktop apps
should_install_optional_desktop_app() {
  local app_name=$1
  local display_name=""

  case "$app_name" in
    *1password*) display_name="1password" ;;
    *asdcontrol*) display_name="ASDControl" ;;
    *audacity*) display_name="Audacity" ;;
    *brave*) display_name="Brave" ;;
    *discord*) display_name="Discord" ;;
    *doom-emacs*) display_name="Doom Emacs" ;;
    *dropbox*) display_name="Dropbox" ;;
    *gimp*) display_name="GIMP" ;;
    *libreoffice*) display_name="LibreOffice" ;;
    *mainline*) display_name="Mainline Kernels" ;;
    *minecraft*) display_name="Minecraft" ;;
    *obsidian*) display_name="Obsidian" ;;
    *retroarch*) display_name="RetroArch" ;;
    *rubymine*) display_name="RubyMine" ;;
    *signal*) display_name="Signal" ;;
    *spotify*) display_name="Spotify" ;;
    *steam*) display_name="Steam" ;;
    *virtualbox*) display_name="VirtualBox" ;;
    *vscode*) display_name="VSCode" ;;
    *select-web-apps*) display_name="Web Apps" ;;
    *windows*) display_name="Windows" ;;
    *windsurf*) display_name="Windsurf" ;;
    *zoom*) display_name="Zoom" ;;
    *) return 1 ;;
  esac

  echo "$OMAKUB_FIRST_RUN_DESKTOP_APPS" | grep -q "$display_name"
}

# Run desktop installers with error handling
failed_installers=()

# Install base desktop installers (flatpak, fonts, etc.)
for installer in ~/.local/share/omakub/install/desktop/{a-,applications,fonts,select-optional,set-}*.sh; do
  [ -f "$installer" ] || continue
  installer_name=$(basename "$installer")
  echo "Running $installer_name..."

  if source "$installer"; then
    echo "✓ $installer_name completed successfully"
  else
    echo "✗ $installer_name failed (exit code: $?)"
    failed_installers+=("$installer_name")
  fi
done

# Install selected default apps
for installer in ~/.local/share/omakub/install/desktop/app-*.sh; do
  [ -f "$installer" ] || continue
  installer_name=$(basename "$installer")

  if should_install_desktop_app "$installer_name"; then
    echo "Running $installer_name..."
    if source "$installer"; then
      echo "✓ $installer_name completed successfully"
    else
      echo "✗ $installer_name failed (exit code: $?)"
      failed_installers+=("$installer_name")
    fi
  else
    echo "⊝ Skipping $installer_name (not selected)"
  fi
done

# Install selected optional apps
for installer in ~/.local/share/omakub/install/desktop/optional/*.sh; do
  [ -f "$installer" ] || continue
  installer_name=$(basename "$installer")

  if should_install_optional_desktop_app "$installer_name"; then
    echo "Running $installer_name..."
    if source "$installer"; then
      echo "✓ $installer_name completed successfully"
    else
      echo "✗ $installer_name failed (exit code: $?)"
      failed_installers+=("$installer_name")
    fi
  else
    echo "⊝ Skipping $installer_name (not selected)"
  fi
done

# Report any failures at the end
if [ ${#failed_installers[@]} -gt 0 ]; then
  echo ""
  echo "WARNING: The following desktop installers failed:"
  for failed in "${failed_installers[@]}"; do
    echo "  - $failed"
  done
  echo ""
  echo "You can retry individual installers later or re-run: source ~/.local/share/omakub/install.sh"
fi

# Logout to pickup changes
gum confirm "Ready to reboot for all settings to take effect?" && sudo reboot || true
