#!/bin/bash

# 1. Install dependencies
sudo apt update
sudo apt install -y build-essential make cmake wl-clipboard git ripgrep python3-pip isort python3-venv libevent-dev ncurses-dev build-essential bison pkg-config xclip jq tidy luarocks bat btop mc mysql-client mysql-server apache2
mkdir -p ~/.local/bin
ln -s /usr/bin/batcat ~/.local/bin/bat
git config user.name "Teodor Petrovic"
git config user.email "teodor.z.petrovic@gmail.com"
curl -fsSL https://bun.sh/install | bash

# 2. Install docker
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl -y
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker

# 3. Redis
sudo apt-get install lsb-release curl gpg -y
curl -fsSL https://packages.redis.io/gpg | sudo gpg --dearmor -o /usr/share/keyrings/redis-archive-keyring.gpg
sudo chmod 644 /usr/share/keyrings/redis-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/redis-archive-keyring.gpg] https://packages.redis.io/deb $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/redis.list
sudo apt-get update
sudo apt-get install redis -y

# 4. Lazygit
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin

# 5. Php
sudo add-apt-repository ppa:ondrej/php -y
sudo apt update
sudo apt install -y php8.3 php8.3-cli php8.3-common php8.3-mysql php8.3-curl php8.3-xml php8.3-mbstring php8.3-zip libapache2-mod-php8.3

# 5. Neovim specific dependencies
sudo luarocks install promise-async
sudo apt install python3-pynvim
curl -fsSL https://deb.nodesource.com/setup_22.x -o nodesource_setup.sh
sudo -E bash nodesource_setup.sh
sudo apt-get install -y nodejs
sudo npm -g install tree-sitter-cli
sudo npm -g install neovim
npm config set bin-links true
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

# 3. Make config directory
REPO="https://github.com/TeodorPetrovic/neovim-config.git"
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

