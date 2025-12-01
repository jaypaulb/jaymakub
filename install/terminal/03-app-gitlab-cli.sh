#!/bin/bash

# GitLab CLI (glab)
if ! command -v glab &>/dev/null; then
  echo "Installing GitLab CLI..."
  GLAB_VERSION="1.36.0"
  curl -sL "https://gitlab.com/gitlab-org/cli/-/releases/v${GLAB_VERSION}/downloads/glab_${GLAB_VERSION}_Linux_x86_64.tar.gz" | sudo tar xz -C /usr/local/bin glab
else
  echo "GitLab CLI already installed"
fi
