#!/bin/bash

# OnlyOffice Desktop Editors
cd /tmp
wget -O onlyoffice.deb "https://download.onlyoffice.com/install/desktop/editors/linux/onlyoffice-desktopeditors_amd64.deb"
sudo apt install -y ./onlyoffice.deb
rm onlyoffice.deb
cd -
