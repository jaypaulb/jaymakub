#!/bin/bash

echo "[app-gum.sh] Checking for gum installation..."

# Gum is used for the Omakub commands for tailoring Omakub after the initial install
if ! command -v gum &>/dev/null; then
  echo "[app-gum.sh] Gum not found, installing version 0.17.0..."
  cd /tmp
  GUM_VERSION="0.17.0"

  echo "[app-gum.sh] Downloading gum from GitHub..."
  if wget -qO gum.deb "https://github.com/charmbracelet/gum/releases/download/v${GUM_VERSION}/gum_${GUM_VERSION}_amd64.deb"; then
    echo "[app-gum.sh] ✓ Download complete"
  else
    echo "[app-gum.sh] ✗ Download failed"
    exit 1
  fi

  echo "[app-gum.sh] Installing gum package..."
  if sudo apt-get install -y --allow-downgrades ./gum.deb; then
    echo "[app-gum.sh] ✓ Gum installed successfully"
  else
    echo "[app-gum.sh] ✗ Gum installation failed"
    exit 1
  fi

  rm gum.deb
  cd -
else
  echo "[app-gum.sh] ✓ Gum already installed, skipping"
fi

# Verify gum is working
if gum --version &>/dev/null; then
  echo "[app-gum.sh] ✓ Gum is functional ($(gum --version))"
else
  echo "[app-gum.sh] ✗ Gum installed but not functional"
  exit 1
fi
