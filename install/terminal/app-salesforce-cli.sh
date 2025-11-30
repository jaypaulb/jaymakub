#!/bin/bash

# Salesforce CLI (sf)
if ! command -v sf &>/dev/null; then
  echo "Installing Salesforce CLI..."
  npm install -g @salesforce/cli
else
  echo "Salesforce CLI already installed"
fi
