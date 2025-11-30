#!/bin/bash

# Helium Browser - https://helium.computer/
cd /tmp

# Get latest AppImage from helium-linux releases
HELIUM_URL=$(curl -s https://api.github.com/repos/imputnet/helium-linux/releases/latest | jq -r '.assets[] | select(.name | endswith(".AppImage")) | .browser_download_url')

if [ -z "$HELIUM_URL" ]; then
  echo "Could not find Helium AppImage download URL"
  exit 1
fi

curl -L -o helium.appimage "$HELIUM_URL"
sudo mv helium.appimage /opt/helium.appimage
sudo chmod +x /opt/helium.appimage
sudo apt install -y fuse3 libfuse2t64

DESKTOP_FILE="/usr/share/applications/helium.desktop"

sudo bash -c "cat > $DESKTOP_FILE" <<EOL
[Desktop Entry]
Name=Helium
Comment=Privacy-focused browser
Exec=/opt/helium.appimage --no-sandbox
Icon=web-browser
Type=Application
Categories=Network;WebBrowser;
EOL

if [ -f "$DESKTOP_FILE" ]; then
  echo "helium.desktop created successfully"
else
  echo "Failed to create helium.desktop"
fi

cd -
