#!/usr/bin/env bash
set -euo pipefail

# Ensure npm/Node.js is available (try nvm first, then system install via NodeSource)
if ! command -v npm >/dev/null 2>&1; then
  echo "npm not found — attempting to make Node.js available..."

  # If nvm is installed, load it and install/use LTS
  if [ -s "$HOME/.nvm/nvm.sh" ]; then
    # shellcheck disable=SC1090
    source "$HOME/.nvm/nvm.sh"
    echo "Using nvm to install/use Node LTS..."
    nvm install --lts || true
    nvm use --lts || true

  else
    # Fall back to system install via NodeSource (requires sudo)
    if command -v sudo >/dev/null 2>&1; then
      echo "Installing Node.js (Node 20 LTS) system-wide via NodeSource..."
      curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
      sudo apt-get update
      sudo apt-get install -y nodejs build-essential || {
        echo "Failed to install nodejs via apt; please install Node.js or nvm and re-run the installer." >&2
        exit 1
      }
    else
      echo "Neither npm nor sudo available. Please install Node.js or nvm and re-run the installer." >&2
      exit 1
    fi
  fi
fi

# Salesforce CLI (sf)
if ! command -v sf &>/dev/null; then
  echo "Installing Salesforce CLI..."
  npm install -g @salesforce/cli
else
  echo "Salesforce CLI already installed"
fi
