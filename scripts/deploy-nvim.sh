#!/bin/bash

# 1. Create a temp directory
TEMP_DIR=$(mktemp -d)
URL="https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz"
curl -Lo "$TEMP_DIR/nvim-linux64.tar.gz" $URL

# 2. Create program folder
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf $TEMP_DIR/nvim-linux64.tar.gz
sudo mv /opt/nvim-linux64 /opt/nvim

# 3. Check if installed and add to user path
if [ -d "/opt/nvim" ]; then
	echo "Neovim installed successfully"
else
	echo "Neovim did not install correctly"
	exit 0
fi

# 4. Adding application to path
USER_HOME=$(eval echo ~$SUDO_USER)
BASHRC_PATH="$USER_HOME/.bashrc"
if ! grep -q "/opt/nvim/bin" "$BASHRC_PATH" ; then
	echo 'export PATH="$PATH:/opt/nvim/bin"' >> "$BASHRC_PATH"
	echo "Adding path to user shell"
else
	echo "Path already exists, do not need to add."
fi

# 5. Removing temp directory
rm -rf $TEMP_DIR

echo "Neovim has been installed. Please run 'source ~/.bashrc' to update your PATH."
