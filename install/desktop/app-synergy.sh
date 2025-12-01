#!/bin/bash

# Share one mouse and keyboard between multiple computers. See https://symless.com/synergy
cd /tmp
wget https://symless.com/synergy/download/package/synergy-personal-v3/ubuntu-24.04/synergy-3.5.0-linux-noble-x86_64.deb
sudo apt install -y ./synergy-3.5.0-linux-noble-x86_64.deb
rm synergy-3.5.0-linux-noble-x86_64.deb
cd -
