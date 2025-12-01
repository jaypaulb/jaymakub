#!/bin/bash

# Exit immediately if a command exits with a non-zero status during setup
# Note: We disable this during the installer loops to allow graceful failure handling
set -e

# Enable debug mode if JAYMAKUB_DEBUG is set
if [[ -n "$JAYMAKUB_DEBUG" ]]; then
  set -x
  export PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'
fi

# Set up install log, state file, and choices file
export JAYMAKUB_LOG="$HOME/.jaymakub-install.log"
export JAYMAKUB_STATE="$HOME/.jaymakub-state"
export JAYMAKUB_CHOICES="$HOME/.jaymakub-choices"

# Logging helper function
log() {
  local level="$1"
  local msg="$2"
  local timestamp=$(date '+%H:%M:%S')
  echo "[$timestamp] [$level] $msg" >> "$JAYMAKUB_LOG"
  echo "[$level] $msg"
}
export -f log

# State tracking functions
mark_done() {
  local item="$1"
  echo "$item" >> "$JAYMAKUB_STATE"
}
export -f mark_done

is_done() {
  local item="$1"
  [[ -f "$JAYMAKUB_STATE" ]] && grep -qxF "$item" "$JAYMAKUB_STATE" 2>/dev/null
}
export -f is_done

# Give people a chance to retry running the installation
trap 'log "ERROR" "Installation failed! You can retry by running: source ~/.local/share/omakub/install.sh"' ERR

# Check the distribution name and version and abort if incompatible
echo "[install.sh] Checking system compatibility..."
if source ~/.local/share/omakub/install/check-version.sh; then
  echo "[install.sh] ✓ System is compatible (Ubuntu 24.04+)"
else
  echo "[install.sh] ✗ System compatibility check failed"
  exit 1
fi

# Install gum first (needed for prompts)
echo "[install.sh] Installing gum (interactive prompt tool)..."
if source ~/.local/share/omakub/install/terminal/required/app-gum.sh >/dev/null 2>&1; then
  echo "[install.sh] ✓ Gum ready"
else
  echo "[install.sh] ✗ Gum installation failed"
  exit 1
fi

# Check for existing installation state
export JAYMAKUB_RESUME="no"
if [[ -f "$JAYMAKUB_STATE" ]]; then
  completed_count=$(wc -l < "$JAYMAKUB_STATE")
  echo ""
  echo "Found previous installation with $completed_count completed steps."
  echo ""
  if gum confirm "Resume previous installation? (No = start fresh)"; then
    export JAYMAKUB_RESUME="yes"
    echo "=== Jaymakub Installation Resumed: $(date) ===" >> "$JAYMAKUB_LOG"
    log "INFO" "Resuming installation ($completed_count steps already complete)"

    # Load saved choices from previous run
    if [[ -f "$JAYMAKUB_CHOICES" ]]; then
      log "INFO" "Loading saved choices from previous run"
      source "$JAYMAKUB_CHOICES"
    fi
  else
    rm -f "$JAYMAKUB_STATE" "$JAYMAKUB_CHOICES"
    echo "=== Jaymakub Installation Started (Fresh): $(date) ===" > "$JAYMAKUB_LOG"
    log "INFO" "Starting fresh installation (cleared previous state)"
  fi
else
  rm -f "$JAYMAKUB_CHOICES"  # Clear any stale choices
  echo "=== Jaymakub Installation Started: $(date) ===" > "$JAYMAKUB_LOG"
  log "INFO" "Starting new installation..."
fi

log "INFO" "Logging to $JAYMAKUB_LOG"
log "INFO" "State file: $JAYMAKUB_STATE"

# Ask for app choices (skip if resuming with saved choices)
if [[ "$JAYMAKUB_RESUME" == "yes" && -f "$JAYMAKUB_CHOICES" ]]; then
  echo "[install.sh] Using saved choices from previous run"
  log "INFO" "HAL restore: $OMAKUB_HAL_RESTORE"
else
  echo "[install.sh] Preparing interactive selection prompts..."
  echo "Get ready to make a few choices..."

  echo "[install.sh] Loading first-run choices..."
  if source ~/.local/share/omakub/install/first-run-choices.sh; then
    echo "[install.sh] ✓ User selections complete"

    # Save choices for resume
    cat > "$JAYMAKUB_CHOICES" << EOF
export OMAKUB_HAL_RESTORE="$OMAKUB_HAL_RESTORE"
export OMAKUB_FIRST_RUN_TERMINAL_APPS="$OMAKUB_FIRST_RUN_TERMINAL_APPS"
export OMAKUB_FIRST_RUN_DESKTOP_APPS="$OMAKUB_FIRST_RUN_DESKTOP_APPS"
export OMAKUB_FIRST_RUN_LANGUAGES="$OMAKUB_FIRST_RUN_LANGUAGES"
export OMAKUB_FIRST_RUN_DBS="$OMAKUB_FIRST_RUN_DBS"
EOF
    log "INFO" "Saved choices to $JAYMAKUB_CHOICES"
  else
    echo "[install.sh] ✗ First-run choices failed"
    exit 1
  fi

  echo "[install.sh] Collecting user identification..."
  if source ~/.local/share/omakub/install/identification.sh; then
    echo "[install.sh] ✓ Identification collected"

    # Append identification to choices
    cat >> "$JAYMAKUB_CHOICES" << EOF
export OMAKUB_USER_NAME="$OMAKUB_USER_NAME"
export OMAKUB_USER_EMAIL="$OMAKUB_USER_EMAIL"
EOF
  else
    echo "[install.sh] ✗ Identification failed"
    exit 1
  fi
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
log "INFO" "HAL restore setting: $OMAKUB_HAL_RESTORE"
if [[ "$OMAKUB_HAL_RESTORE" == "yes" ]]; then
  log "INFO" "Starting HAL configs restore..."
  source ~/.local/share/omakub/install/hal-restore-configs.sh
  log "OK" "HAL configs restore complete"
else
  log "INFO" "Skipping HAL configs restore (not selected)"
fi

log "OK" "Jaymakub installation complete!"

# Reboot prompt - at the very end after all phases complete
gum confirm "Ready to reboot for all settings to take effect?" && sudo reboot || true
