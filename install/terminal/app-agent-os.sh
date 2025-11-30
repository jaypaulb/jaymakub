#!/bin/bash

# Agent-OS from buildermethods
if [[ ! -d "$HOME/agent-os" ]]; then
  echo "Installing Agent-OS..."
  curl -sSL https://raw.githubusercontent.com/buildermethods/agent-os/main/scripts/base-install.sh | bash
else
  echo "Agent-OS already installed"
fi
