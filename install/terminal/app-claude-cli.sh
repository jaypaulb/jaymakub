#!/bin/bash

# Claude Code CLI from Anthropic
if ! command -v claude &>/dev/null; then
  echo "Installing Claude Code CLI..."
  npm install -g @anthropic-ai/claude-code
else
  echo "Claude Code CLI already installed"
fi
