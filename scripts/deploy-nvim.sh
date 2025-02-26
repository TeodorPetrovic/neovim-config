#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

# 1. Create a temp directory
TEMP_DIR=$(mktemp -d)
URL="https://github.com/neovim/neovim/releases/download/v0.10.4/nvim-linux-x86_64.tar.gz"

# Download Neovim with proper error handling
echo "Downloading Neovim from $URL..."
curl -fL --retry 3 -o "$TEMP_DIR/nvim-linux-x86_64.tar.gz" "$URL"

# Verify if the downloaded file is a valid gzip archive
if ! file "$TEMP_DIR/nvim-linux-x86_64.tar.gz" | grep -q 'gzip compressed data'; then
    echo "Error: Downloaded file is not a valid tar.gz archive."
    cat "$TEMP_DIR/nvim-linux-x86_64.tar.gz"  # Show content for debugging
    exit 1
fi

# 2. Create program folder and extract
echo "Extracting Neovim..."
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf "$TEMP_DIR/nvim-linux-x86_64.tar.gz"
sudo mv /opt/nvim-linux-x86_64 /opt/nvim

# 3. Check if installed
if [ -d "/opt/nvim" ]; then
    echo "✅ Neovim installed successfully!"
else
    echo "❌ Neovim did not install correctly."
    exit 1
fi

# 4. Add Neovim to user PATH
USER_HOME=$(eval echo ~$SUDO_USER)
BASHRC_PATH="$USER_HOME/.bashrc"

if ! grep -q "/opt/nvim/bin" "$BASHRC_PATH"; then
    echo 'export PATH="$PATH:/opt/nvim/bin"' | sudo tee -a "$BASHRC_PATH"
    echo "🔧 Neovim path added to ~/.bashrc"
else
    echo "ℹ️ Neovim path already exists in ~/.bashrc"
fi

# 5. Clean up
rm -rf "$TEMP_DIR"

echo "🎉 Neovim has been installed! Run 'source ~/.bashrc' to update your PATH."
