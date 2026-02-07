#!/bin/bash

# Configuration
REPO="Sibikrish3000/pokemon-colorscripts-rs"
BIN_NAME="pokemon-rs"
INSTALL_DIR="$HOME/.local/bin"

# 1. Ensure local bin exists
mkdir -p "$INSTALL_DIR"

# 2. Identify Architecture
ARCH=$(uname -m)
case "$ARCH" in
    x86_64)  SUFFIX="x86_64-unknown-linux-gnu" ;;
    aarch64) SUFFIX="aarch64-unknown-linux-gnu" ;;
    *)       echo "Unsupported architecture: $ARCH"; exit 1 ;;
esac

echo "--- Installing $BIN_NAME for $ARCH ---"

# 3. Fetch latest release URL from GitHub API
RELEASE_URL=$(curl -s https://api.github.com/repos/$REPO/releases/latest \
    | grep "browser_download_url.*$SUFFIX" \
    | cut -d '"' -f 4)

if [ -z "$RELEASE_URL" ]; then
    echo "Error: Could not find a binary for $ARCH in the latest release."
    exit 1
fi

# 4. Download and Set Permissions
echo "Downloading from: $RELEASE_URL"
curl -L "$RELEASE_URL" -o "$INSTALL_DIR/$BIN_NAME"
chmod +x "$INSTALL_DIR/$BIN_NAME"

# 5. Verify PATH
if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
    echo "Warning: $INSTALL_DIR is not in your PATH."
    echo "Add 'export PATH=\"\$HOME/.local/bin:\$PATH\"' to your .zshrc"
fi

echo "--- Installation Complete: Try running '$BIN_NAME' ---"
