#!/bin/bash

echo "Enter identification for git and autocomplete..."

# Try to get existing values from git config, fall back to system info
EXISTING_NAME=$(git config --global user.name 2>/dev/null)
EXISTING_EMAIL=$(git config --global user.email 2>/dev/null)
SYSTEM_NAME=$(getent passwd "$USER" | cut -d ':' -f 5 | cut -d ',' -f 1)

# Use existing git config if available, otherwise system name
DEFAULT_NAME="${EXISTING_NAME:-$SYSTEM_NAME}"
DEFAULT_EMAIL="${EXISTING_EMAIL:-}"

export OMAKUB_USER_NAME=$(gum input --placeholder "Enter full name" --value "$DEFAULT_NAME" --prompt "Name> ")
export OMAKUB_USER_EMAIL=$(gum input --placeholder "Enter email address" --value "$DEFAULT_EMAIL" --prompt "Email> ")
