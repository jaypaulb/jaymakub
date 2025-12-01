#!/bin/bash

set -e

# Enable debug mode if JAYMAKUB_DEBUG is set
if [[ -n "$JAYMAKUB_DEBUG" ]]; then
  set -x
  export PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'
fi

ascii_art='
     __                              __        __
    / /___ ___  ______ ___  ____ _  / /____  __/ /_
   / / __ `/ / / / __ `__ \/ __ `/ / //_/ / / / __ \
  / / /_/ / /_/ / / / / / / /_/ / / ,< / /_/ / /_/ /
 /_/\__,_/\__, /_/ /_/ /_/\__,_/ /_/|_|\__,_/_.___/
         /____/
'

echo -e "$ascii_art"
echo "=> Jaymakub is for fresh Ubuntu 24.04+ installations only!"
echo -e "\nBegin installation (or abort with ctrl+c)..."

echo "[boot.sh] Checking sudo access..."
# Request sudo upfront and keep it alive
if sudo -v; then
  echo "[boot.sh] ✓ Sudo access granted"
  while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
  echo "[boot.sh] ✓ Sudo keepalive started (PID: $!)"
else
  echo "[boot.sh] ✗ Failed to get sudo access"
  exit 1
fi

echo "[boot.sh] Checking for git..."
if command -v git &>/dev/null; then
  echo "[boot.sh] ✓ git already installed"
else
  echo "[boot.sh] Installing git..."
  if sudo apt-get update >/dev/null 2>&1 && sudo apt-get install -y git >/dev/null 2>&1; then
    echo "[boot.sh] ✓ git installed"
  else
    echo "[boot.sh] ✗ git installation failed"
    exit 1
  fi
fi

echo "[boot.sh] Cloning Jaymakub repository..."
rm -rf ~/.local/share/omakub
if git clone https://github.com/jaypaulb/jaymakub.git ~/.local/share/omakub >/dev/null 2>&1; then
  echo "[boot.sh] ✓ Repository cloned to ~/.local/share/omakub"
else
  echo "[boot.sh] ✗ Repository clone failed"
  exit 1
fi

if [[ -n $OMAKUB_REF && $OMAKUB_REF != "master" ]]; then
  echo "[boot.sh] Checking out branch: $OMAKUB_REF"
	cd ~/.local/share/omakub
	if git fetch origin "${OMAKUB_REF}" && git checkout "${OMAKUB_REF}"; then
	  echo "[boot.sh] ✓ Checked out $OMAKUB_REF"
	else
	  echo "[boot.sh] ✗ Failed to checkout $OMAKUB_REF"
	  exit 1
	fi
	cd -
else
  echo "[boot.sh] Using master branch (default)"
fi

echo "[boot.sh] Starting main installation script..."
source ~/.local/share/omakub/install.sh
echo "[boot.sh] ✓ Installation complete!"
