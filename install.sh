#!/bin/bash

# Exit immediately if a command exits with a non-zero status during setup
# Note: We disable this during the installer loops to allow graceful failure handling
set -e

# Give people a chance to retry running the installation
trap 'echo "Jaymakub installation failed! You can retry by running: source ~/.local/share/omakub/install.sh"' ERR

# Check the distribution name and version and abort if incompatible
source ~/.local/share/omakub/install/check-version.sh

# Ask for app choices
echo "Get ready to make a few choices..."
source ~/.local/share/omakub/install/terminal/required/app-gum.sh >/dev/null
source ~/.local/share/omakub/install/first-run-choices.sh
source ~/.local/share/omakub/install/identification.sh

# Optional: Restore SSH/GPG keys and configs from HAL backup server
if [[ "$OMAKUB_HAL_RESTORE" == "yes" ]]; then
  source ~/.local/share/omakub/install/hal-restore.sh
fi

# Desktop software and tweaks will only be installed if we're running Gnome
if [[ "$XDG_CURRENT_DESKTOP" == *"GNOME"* ]]; then
  # Ensure computer doesn't go to sleep or lock while installing
  gsettings set org.gnome.desktop.screensaver lock-enabled false
  gsettings set org.gnome.desktop.session idle-delay 0

  echo "Installing terminal and desktop tools..."

  # Install terminal tools (disable set -e to allow graceful failure handling)
  set +e
  source ~/.local/share/omakub/install/terminal.sh
  set -e

  # Install desktop tools and tweaks (disable set -e to allow graceful failure handling)
  set +e
  source ~/.local/share/omakub/install/desktop.sh
  set -e

  # Revert to normal idle and lock settings
  gsettings set org.gnome.desktop.screensaver lock-enabled true
  gsettings set org.gnome.desktop.session idle-delay 300
else
  echo "Only installing terminal tools..."
  # Disable set -e to allow graceful failure handling
  set +e
  source ~/.local/share/omakub/install/terminal.sh
  set -e
fi
