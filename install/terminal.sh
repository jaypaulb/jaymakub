#!/bin/bash

# Use log function from install.sh, or define fallback
if ! declare -f log > /dev/null; then
  log() { echo "[$1] $2"; }
fi

log "INFO" "=== Terminal Installers Started ==="

# Needed for all installers
sudo apt update -y
sudo apt upgrade -y
sudo apt install -y curl git unzip

# Helper function to check if app was selected
should_install_terminal_app() {
  local app_name=$1
  # Convert filename to display name (e.g., "03-app-claude-cli.sh" -> "Claude CLI")
  local display_name=""

  case "$app_name" in
    *agent-os*) display_name="Agent-OS" ;;
    *azure-cli*) display_name="Azure CLI" ;;
    *btop*) display_name="Btop" ;;
    *claude-cli*) display_name="Claude CLI" ;;
    *fastfetch*) display_name="Fastfetch" ;;
    *gemini-cli*) display_name="Gemini CLI" ;;
    *github-cli*) display_name="GitHub CLI" ;;
    *gitlab-cli*) display_name="GitLab CLI" ;;
    *lazydocker*) display_name="LazyDocker" ;;
    *lazygit*) display_name="LazyGit" ;;
    *neovim*) display_name="Neovim" ;;
    *salesforce-cli*) display_name="Salesforce CLI" ;;
    *zellij*) display_name="Zellij" ;;
    *) return 0 ;; # Install non-app installers (libraries, mise, etc.)
  esac

  # Check if app is in the selected list
  echo "$OMAKUB_FIRST_RUN_TERMINAL_APPS" | grep -q "$display_name"
}

# Helper function to check optional terminal apps
should_install_optional_terminal_app() {
  local app_name=$1
  local display_name=""

  case "$app_name" in
    *docker*) display_name="Docker" ;;
    *geekbench*) display_name="Geekbench" ;;
    *ollama*) display_name="Ollama" ;;
    *tailscale*) display_name="Tailscale" ;;
    *) return 1 ;;
  esac

  echo "$OMAKUB_FIRST_RUN_TERMINAL_APPS" | grep -q "$display_name"
}

# Run terminal installers with error handling
failed_installers=()

# Install required dependencies and base installers (01-*, 02-*, 04-*)
for installer in ~/.local/share/omakub/install/terminal/{01,02,04}-*.sh; do
  [ -f "$installer" ] || continue
  installer_name=$(basename "$installer")
  log "INFO" "Running $installer_name..."

  if source "$installer" 2>&1 | tee -a "$JAYMAKUB_LOG"; then
    log "OK" "$installer_name completed"
  else
    log "FAIL" "$installer_name failed (exit code: $?)"
    failed_installers+=("$installer_name")
  fi
done

# Install selected apps (03-*)
for installer in ~/.local/share/omakub/install/terminal/03-*.sh; do
  [ -f "$installer" ] || continue
  installer_name=$(basename "$installer")

  if should_install_terminal_app "$installer_name"; then
    log "INFO" "Running $installer_name..."
    if source "$installer" 2>&1 | tee -a "$JAYMAKUB_LOG"; then
      log "OK" "$installer_name completed"
    else
      log "FAIL" "$installer_name failed (exit code: $?)"
      failed_installers+=("$installer_name")
    fi
  else
    log "SKIP" "$installer_name (not selected)"
  fi
done

# Install selected optional apps
for installer in ~/.local/share/omakub/install/terminal/optional/*.sh; do
  [ -f "$installer" ] || continue
  installer_name=$(basename "$installer")

  if should_install_optional_terminal_app "$installer_name"; then
    log "INFO" "Running $installer_name..."
    if source "$installer" 2>&1 | tee -a "$JAYMAKUB_LOG"; then
      log "OK" "$installer_name completed"
    else
      log "FAIL" "$installer_name failed (exit code: $?)"
      failed_installers+=("$installer_name")
    fi
  else
    log "SKIP" "$installer_name (not selected)"
  fi
done

# Report any failures at the end
if [ ${#failed_installers[@]} -gt 0 ]; then
  log "WARN" "The following terminal installers failed:"
  for failed in "${failed_installers[@]}"; do
    log "WARN" "  - $failed"
  done
fi

log "INFO" "=== Terminal Installers Finished ==="
