#!/bin/bash

# Logseq is a privacy-first, open-source knowledge base. See https://logseq.com
cd /tmp
LOGSEQ_VERSION=$(curl -s https://api.github.com/repos/logseq/logseq/releases/latest | grep -Po '"tag_name": "\K[^"]*')
wget -O logseq.deb "https://github.com/logseq/logseq/releases/latest/download/Logseq-linux-x64-${LOGSEQ_VERSION}.deb"
sudo apt install -y ./logseq.deb
rm logseq.deb
cd -
