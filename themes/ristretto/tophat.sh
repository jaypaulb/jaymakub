#!/bin/bash

# Only set tophat color if the extension schema is available
if gsettings list-schemas 2>/dev/null | grep -q "org.gnome.shell.extensions.tophat"; then
  gsettings set org.gnome.shell.extensions.tophat meter-fg-color "#2c2525"
fi
