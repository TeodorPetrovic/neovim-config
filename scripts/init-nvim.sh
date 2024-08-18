#!/bin/bash

# 1. Install dependencies
sudo apt update
sudo apt install -y build-essential make cmake wl-clipboard git ripgrep python3-pip isort python3-venv libevent-dev ncurses-dev build-essential bison pkg-config xclip jq tidy luarocks
pip install neovim
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo bash -
sudo apt install -y nodejs
sudo npm -g install tree-sitter-cli
sudo npm -g install neovim
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

# 2. Make config directory
REPO="https://github.com/TeodorPetrovic/NeoVim-Final.git"
USER_HOME=$(eval echo ~$SUDO_USER)
NVIM_CONFIG="$USER_HOME/.config/nvim"
NVIM_LOCAL="$USER_HOME/.local/share/nvim"
NVIM_CACHE="$USER_HOME/.cache/nvim"

if [ -d $NVIM_LOCAL ]; then
  rm -rf $NVIM_LOCAL
fi
if [ -d $NVIM_CACHE ]; then
  rm -rf $NVIM_LOCAL
fi

if [ -d $NVIM_CONFIG ]; then
  echo "Neovim already initialized, erasing old and getting new config ..."
  rm -rf $NVIM_CONFIG
  git clone $REPO $NVIM_CONFIG
else
  echo "Neovim is not initialized, getting config ..."
  git clone $REPO $NVIM_CONFIG
fi

