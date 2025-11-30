#!/bin/bash

# Google Gemini CLI
if ! command -v gemini &>/dev/null; then
  echo "Installing Gemini CLI..."
  npm install -g @google/generative-ai-cli
else
  echo "Gemini CLI already installed"
fi
