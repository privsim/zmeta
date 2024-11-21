#!/bin/bash

# Step 1: Find the latest version of the .AppImage
LATEST_APPIMAGE=$(ls -t $HOME/Applications/cursor-*.AppImage | head -n 1)
echo "Latest AppImage: $LATEST_APPIMAGE"

# Step 2: Update symlink to the latest version
SYMLINK_PATH="$HOME/Applications/cursor.AppImage"
ln -sf $LATEST_APPIMAGE $SYMLINK_PATH
echo "Updated symlink to: $SYMLINK_PATH"

# Step 3: Download the Cursor logo if not exists
ICON_PATH="$HOME/.local/share/icons/cursor-icon.svg"
if [ ! -f "$ICON_PATH" ]; then
  mkdir -p $(dirname $ICON_PATH)
  curl -o $ICON_PATH "https://www.cursor.so/brand/icon.svg"
  echo "Downloaded logo to: $ICON_PATH"
fi

# Step 4: Conditionally create or update the .desktop file
DESKTOP_FILE_PATH="$HOME/.local/share/applications/cursor.desktop"
if [ ! -f "$DESKTOP_FILE_PATH" ] || [ "$LATEST_APPIMAGE" != "$(grep -oP '(?<=^Exec=).*' $DESKTOP_FILE_PATH)" ]; then
  DESKTOP_FILE_CONTENT="[Desktop Entry]
Name=Cursor
Exec=$SYMLINK_PATH
Terminal=false
Type=Application
Icon=$ICON_PATH
StartupWMClass=Cursor
X-AppImage-Version=latest
Comment=Cursor is an AI-first coding environment.
MimeType=x-scheme-handler/cursor;
Categories=Utility;Development
"
  echo "$DESKTOP_FILE_CONTENT" > $DESKTOP_FILE_PATH
  chmod +x $DESKTOP_FILE_PATH
  echo "Updated .desktop file at: $DESKTOP_FILE_PATH"
else
  echo ".desktop file is up-to-date."
fi
