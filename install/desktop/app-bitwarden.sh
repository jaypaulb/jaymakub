#!/bin/bash

# Bitwarden password manager
cd /tmp
wget -O bitwarden.deb "https://vault.bitwarden.com/download/?app=desktop&platform=linux&variant=deb"
sudo apt install -y ./bitwarden.deb
rm bitwarden.deb
cd -
