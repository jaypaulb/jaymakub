#!/bin/bash

# Exit immediately if a command exits with a non-zero status during setup
# Note: We disable this during the installer loops to allow graceful failure handling
set -e

# Enable debug mode if JAYMAKUB_DEBUG is set
if [[ -n "$JAYMAKUB_DEBUG" ]]; then
  set -x
  export PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'
fi

# Give people a chance to retry running the installation
trap 'echo "[install.sh] ✗ Installation failed! You can retry by running: source ~/.local/share/omakub/install.sh"' ERR

echo "[install.sh] Starting Jaymakub installation..."

# Check the distribution name and version and abort if incompatible
echo "[install.sh] Checking system compatibility..."
if source ~/.local/share/omakub/install/check-version.sh; then
  echo "[install.sh] ✓ System is compatible (Ubuntu 24.04+)"
else
  echo "[install.sh] ✗ System compatibility check failed"
  exit 1
fi

# Ask for app choices
echo "[install.sh] Preparing interactive selection prompts..."
echo "Get ready to make a few choices..."

echo "[install.sh] Installing gum (interactive prompt tool)..."
if source ~/.local/share/omakub/install/terminal/required/app-gum.sh >/dev/null 2>&1; then
  echo "[install.sh] ✓ Gum ready"
else
  echo "[install.sh] ✗ Gum installation failed"
  exit 1
fi

echo "[install.sh] Loading first-run choices..."
if source ~/.local/share/omakub/install/first-run-choices.sh; then
  echo "[install.sh] ✓ User selections complete"
else
  echo "[install.sh] ✗ First-run choices failed"
  exit 1
fi

echo "[install.sh] Collecting user identification..."
if source ~/.local/share/omakub/install/identification.sh; then
  echo "[install.sh] ✓ Identification collected"
else
  echo "[install.sh] ✗ Identification failed"
  exit 1
fi

# Optional: Restore SSH/GPG keys from HAL backup server (runs early for git operations)
if [[ "$OMAKUB_HAL_RESTORE" == "yes" ]]; then
  echo "[install.sh] Restoring keys from HAL backup..."
  source ~/.local/share/omakub/install/hal-restore-keys.sh
  echo "[install.sh] ✓ HAL keys restore complete"
fi

# Desktop software and tweaks will only be installed if we're running Gnome
if [[ "$XDG_CURRENT_DESKTOP" == *"GNOME"* ]]; then
  echo "[install.sh] Detected GNOME desktop environment"

  # Ensure computer doesn't go to sleep or lock while installing
  echo "[install.sh] Disabling screen lock and sleep during installation..."
  gsettings set org.gnome.desktop.screensaver lock-enabled false
  gsettings set org.gnome.desktop.session idle-delay 0

  echo "[install.sh] Installing terminal and desktop tools..."

  # Install terminal tools (disable set -e to allow graceful failure handling)
  echo "[install.sh] Running terminal installers..."
  set +e
  source ~/.local/share/omakub/install/terminal.sh
  set -e
  echo "[install.sh] ✓ Terminal installers complete"

  # Install desktop tools and tweaks (disable set -e to allow graceful failure handling)
  echo "[install.sh] Running desktop installers..."
  set +e
  source ~/.local/share/omakub/install/desktop.sh
  set -e
  echo "[install.sh] ✓ Desktop installers complete"

  # Revert to normal idle and lock settings
  echo "[install.sh] Restoring screen lock and sleep settings..."
  gsettings set org.gnome.desktop.screensaver lock-enabled true
  gsettings set org.gnome.desktop.session idle-delay 300
else
  echo "[install.sh] No GNOME detected - terminal-only installation"
  # Disable set -e to allow graceful failure handling
  echo "[install.sh] Running terminal installers..."
  set +e
  source ~/.local/share/omakub/install/terminal.sh
  set -e
  echo "[install.sh] ✓ Terminal installers complete"
fi

# Optional: Restore configs from HAL backup server (runs last so configs aren't overwritten)
if [[ "$OMAKUB_HAL_RESTORE" == "yes" ]]; then
  echo "[install.sh] Restoring configs from HAL backup..."
  source ~/.local/share/omakub/install/hal-restore-configs.sh
  echo "[install.sh] ✓ HAL configs restore complete"
fi

echo "[install.sh] ✓ Jaymakub installation complete!"
