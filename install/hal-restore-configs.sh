#!/bin/bash

# HAL Restore Configs - Restore shell and app configs from HAL backup server (runs last)
# This runs AFTER installers so restored configs aren't overwritten by defaults

if [[ "$OMAKUB_HAL_RESTORE" != "yes" ]]; then
  exit 0
fi

# HAL Configuration
HAL_HOST="192.168.1.4"
HAL_USER="${USER}"
HAL_BACKUP_PATH="/home/${USER}/backups/PopMigration"
HAL_HOME="${HAL_BACKUP_PATH}/ubuntu/home"
LOCAL_HOME="${HOME}"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[OK]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

check_hal_connection() {
    log_info "Testing connection to HAL (${HAL_HOST})..."
    if ssh -q -o ConnectTimeout=5 "${HAL_USER}@${HAL_HOST}" exit 2>/dev/null; then
        log_success "HAL connection successful"
        return 0
    else
        log_error "Cannot connect to HAL at ${HAL_HOST}"
        log_info "Make sure you're on the same network and SSH is configured"
        return 1
    fi
}

restore_file() {
    local remote_path="$1"
    local local_path="$2"
    local desc="$3"

    if ssh "${HAL_USER}@${HAL_HOST}" "test -f ${remote_path}" 2>/dev/null; then
        scp -q "${HAL_USER}@${HAL_HOST}:${remote_path}" "$local_path" 2>/dev/null
        log_success "$desc restored"
    else
        log_warn "$desc not found in backup"
    fi
}

restore_dir() {
    local remote_path="$1"
    local local_path="$2"
    local desc="$3"

    if ssh "${HAL_USER}@${HAL_HOST}" "test -d ${remote_path}" 2>/dev/null; then
        mkdir -p "$local_path"
        scp -rq "${HAL_USER}@${HAL_HOST}:${remote_path}/"* "$local_path/" 2>/dev/null || true
        local file_count=$(find "$local_path" -type f 2>/dev/null | wc -l)
        log_success "$desc restored (${file_count} files)"
    else
        log_warn "$desc not found in backup"
    fi
}

restore_shell_configs() {
    log_info "Restoring shell configurations..."

    # Shell config files
    for file in .bashrc .bash_profile .profile .aliases .inputrc .gitconfig .claude.json; do
        restore_file "${HAL_HOME}/${file}" "${LOCAL_HOME}/${file}" "${file}"
    done
}

restore_app_configs() {
    log_info "Restoring application configurations..."

    # Config directories
    for dir in .claude .vscode .cursor .docker .azure .sf .sfdx; do
        restore_dir "${HAL_HOME}/${dir}" "${LOCAL_HOME}/${dir}" "${dir} directory"
    done

    # Additional config files
    restore_file "${HAL_HOME}/.streamdeck_ui.json" "${LOCAL_HOME}/.streamdeck_ui.json" "Stream Deck UI"
    restore_file "${HAL_HOME}/.XCompose" "${LOCAL_HOME}/.XCompose" "XCompose"
}

# Main execution
echo
echo "=== HAL Restore: Configs Phase ==="
echo "Restoring shell and app configs from HAL (${HAL_HOST})"
echo

if check_hal_connection; then
    echo

    if gum confirm "Restore shell configs (.bashrc, .gitconfig, etc.)?"; then
        restore_shell_configs
    fi
    echo

    if gum confirm "Restore app configs (.claude, .cursor, .vscode, etc.)?"; then
        restore_app_configs
    fi
    echo

    log_success "HAL configs restore complete"
else
    log_warn "Skipping HAL config restore - server not reachable"
    log_info "You can manually restore configs later"
fi
