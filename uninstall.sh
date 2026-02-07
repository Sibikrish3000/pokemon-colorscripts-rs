#!/bin/bash

# Configuration
BIN_NAME="pokemon-rs"
OLD_BIN_NAME="pokemon-colorscripts"
LOCAL_BIN="$HOME/.local/bin"
SYSTEM_BIN="/usr/bin"

echo "--- Uninstalling $BIN_NAME ---"

# 1. Remove from local bin (Used by install.sh)
if [[ -f "$LOCAL_BIN/$BIN_NAME" ]]; then
    rm -f "$LOCAL_BIN/$BIN_NAME"
    echo "Removed $BIN_NAME from $LOCAL_BIN"
fi

# 2. Remove symlinks or old names
if [[ -f "$LOCAL_BIN/$OLD_BIN_NAME" ]]; then
    rm -f "$LOCAL_BIN/$OLD_BIN_NAME"
    echo "Removed old binary alias from $LOCAL_BIN"
fi

# 3. Clean up System Bin (If installed via sudo/manual move)
if [[ -f "$SYSTEM_BIN/$BIN_NAME" ]]; then
    echo "Requires sudo to remove from $SYSTEM_BIN"
    sudo rm -f "$SYSTEM_BIN/$BIN_NAME"
    sudo rm -f "$SYSTEM_BIN/$OLD_BIN_NAME"
fi

# 4. Optional: Clean up cache
CACHE_DIR="$HOME/.cache/pokemon-rs"
if [[ -d "$CACHE_DIR" ]]; then
    rm -rf "$CACHE_DIR"
    echo "Cleaned up cache directory."
fi

echo "--- Uninstallation Complete ---"
