#!/bin/bash

set -e

# === Define installation directory ===
INSTALL_DIR="$HOME/suckless"
mkdir -p "$INSTALL_DIR"
cd "$INSTALL_DIR"

# === Install required packages ===
echo "📦 Installing dependencies..."
sudo apt update
sudo apt install -y \
    git build-essential wget curl \
    libx11-dev libxft-dev libxinerama-dev libxrender-dev libxext-dev \
    libharfbuzz-dev \
    xorg xserver-xorg xinit x11-xserver-utils x11-utils xterm

# === Clone suckless repositories ===
echo "📁 Cloning suckless software..."
git clone https://git.suckless.org/dwm
git clone https://git.suckless.org/st
git clone https://git.suckless.org/dmenu

# === Build and install dwm ===
echo "🛠 Building and installing dwm..."
cd "$INSTALL_DIR/dwm"
sudo make clean install

# === Build and install st ===
echo "🛠 Building and installing st..."
cd "$INSTALL_DIR/st"
sudo make clean install

# === Build and install dmenu ===
echo "🛠 Building and installing dmenu..."
cd "$INSTALL_DIR/dmenu"
sudo make clean install

# === Setup .xinitrc to launch dwm ===
echo "🧾 Setting up .xinitrc..."
echo "exec dwm" > "$HOME/.xinitrc"

# === Optional: Enable login to startx automatically ===
echo "✅ All done! You can now run 'startx' to launch dwm."
echo "👉 If you want dwm to auto-start at login, add this to your ~/.bash_profile or ~/.bashrc:"
echo '[[ -z $DISPLAY && $(tty) = /dev/tty1 ]] && startx'
