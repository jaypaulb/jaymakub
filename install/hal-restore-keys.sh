#!/bin/bash

# HAL Restore Keys - Restore SSH/GPG keys from HAL backup server (runs early)
# This runs BEFORE installers so keys are available for git operations

if [[ "$OMAKUB_HAL_RESTORE_KEYS" != "yes" ]]; then
  exit 0
fi

# HAL Configuration
HAL_HOST="192.168.1.4"
HAL_USER="${USER}"
HAL_BACKUP_PATH="/home/${USER}/backups/PopMigration"
HAL_KEYS="${HAL_BACKUP_PATH}/ubuntu/keys"
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
        export HAL_CONNECTED=yes
        return 0
    else
        log_error "Cannot connect to HAL at ${HAL_HOST}"
        log_info "Make sure you're on the same network and SSH is configured"
        export HAL_CONNECTED=no
        return 1
    fi
}

restore_ssh_keys() {
    log_info "Restoring SSH keys from HAL..."
    mkdir -p "${LOCAL_HOME}/.ssh"
    chmod 700 "${LOCAL_HOME}/.ssh"

    if ssh "${HAL_USER}@${HAL_HOST}" "test -d ${HAL_KEYS}/ssh" 2>/dev/null; then
        scp -rq "${HAL_USER}@${HAL_HOST}:${HAL_KEYS}/ssh/"* "${LOCAL_HOME}/.ssh/" 2>/dev/null || true

        # Set correct permissions
        chmod 600 "${LOCAL_HOME}/.ssh/id_"* 2>/dev/null || true
        chmod 644 "${LOCAL_HOME}/.ssh/"*.pub 2>/dev/null || true
        chmod 644 "${LOCAL_HOME}/.ssh/config" 2>/dev/null || true
        chmod 644 "${LOCAL_HOME}/.ssh/known_hosts" 2>/dev/null || true

        # Add keys to ssh-agent
        eval "$(ssh-agent -s)" >/dev/null 2>&1
        for key in "${LOCAL_HOME}/.ssh/id_"*; do
            [[ "$key" != *.pub ]] && ssh-add "$key" 2>/dev/null || true
        done

        log_success "SSH keys restored and added to agent"
    else
        log_warn "SSH keys not found in backup"
    fi
}

restore_gpg_keys() {
    log_info "Restoring GPG keys from HAL..."
    mkdir -p "${LOCAL_HOME}/.gnupg"
    chmod 700 "${LOCAL_HOME}/.gnupg"

    if ssh "${HAL_USER}@${HAL_HOST}" "test -d ${HAL_KEYS}/gpg" 2>/dev/null; then
        scp -rq "${HAL_USER}@${HAL_HOST}:${HAL_KEYS}/gpg/"* "${LOCAL_HOME}/.gnupg/" 2>/dev/null || true

        # Set correct permissions
        chmod 700 "${LOCAL_HOME}/.gnupg"
        chmod 600 "${LOCAL_HOME}/.gnupg/private-keys-v1.d/"* 2>/dev/null || true
        chmod 600 "${LOCAL_HOME}/.gnupg/pubring.kbx" 2>/dev/null || true
        chmod 600 "${LOCAL_HOME}/.gnupg/trustdb.gpg" 2>/dev/null || true

        log_success "GPG keys restored"
    else
        log_warn "GPG keys not found in backup"
    fi
}

# Main execution
echo
echo "=== HAL Restore: Keys Phase ==="
echo "Restoring SSH/GPG keys from HAL (${HAL_HOST})"
echo

if check_hal_connection; then
    echo

    if gum confirm "Restore SSH keys?"; then
        restore_ssh_keys
    fi
    echo

    if gum confirm "Restore GPG keys?"; then
        restore_gpg_keys
    fi
    echo

    log_success "HAL keys restore complete"
else
    log_warn "Skipping HAL key restore - server not reachable"
    log_info "You can manually restore keys later"
fi
