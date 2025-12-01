#!/bin/bash

set -e

ascii_art='
     __                              __        __
    / /___ ___  ______ ___  ____ _  / /____  __/ /_
   / / __ `/ / / / __ `__ \/ __ `/ / //_/ / / / __ \
  / / /_/ / /_/ / / / / / / /_/ / / ,< / /_/ / /_/ /
 /_/\__,_/\__, /_/ /_/ /_/\__,_/ /_/|_|\__,_/_.___/
         /____/
'

echo -e "$ascii_art"
echo "=> Jaymakub is for fresh Ubuntu 24.04+ installations only!"
echo -e "\nBegin installation (or abort with ctrl+c)..."

# Request sudo upfront and keep it alive
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

sudo apt-get update >/dev/null
sudo apt-get install -y git >/dev/null

echo "Cloning Jaymakub..."
rm -rf ~/.local/share/omakub
git clone https://github.com/jaypaulb/jaymakub.git ~/.local/share/omakub >/dev/null
if [[ -n $OMAKUB_REF && $OMAKUB_REF != "master" ]]; then
	cd ~/.local/share/omakub
	git fetch origin "${OMAKUB_REF}" && git checkout "${OMAKUB_REF}"
	cd -
fi

echo "Installation starting..."
source ~/.local/share/omakub/install.sh
