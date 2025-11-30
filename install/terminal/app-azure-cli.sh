#!/bin/bash

# Azure CLI
if ! command -v az &>/dev/null; then
  echo "Installing Azure CLI..."
  curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
else
  echo "Azure CLI already installed"
fi
