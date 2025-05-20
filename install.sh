#!/bin/bash

# Location to clone suckless software
INSTALL_DIR="$HOME/suckless"
mkdir -p "$INSTALL_DIR"
cd "$INSTALL_DIR" || exit 1

echo "Installing dependencies..."
if command -v apt >/dev/null 2>&1; then
    sudo apt update
    sudo apt install -y git libx11-dev libxft-dev libxinerama-dev libharfbuzz-dev libxrender-dev libxext-dev build-essential
elif command -v pacman >/dev/null 2>&1; then
    sudo pacman -Syu --noconfirm
    sudo pacman -S --noconfirm git libx11 libxft libxinerama harfbuzz xorg-server-devel make gcc
else
    echo "Unsupported package manager. Install dependencies manually."
    exit 1
fi

# Function to apply patches
apply_patch() {
    PATCH_URL="$1"
    PATCH_NAME=$(basename "$PATCH_URL")
    wget -O "$PATCH_NAME" "$PATCH_URL"
    patch -p1 < "$PATCH_NAME"
    rm "$PATCH_NAME"
}

### DWM ###
echo "Cloning and patching dwm..."
git clone https://git.suckless.org/dwm
cd dwm || exit 1

# Apply DWM patches
apply_patch "https://dwm.suckless.org/patches/vanitygaps/dwm-vanitygaps-6.4.diff"
apply_patch "https://dwm.suckless.org/patches/pertag/dwm-pertag-6.2.diff"
apply_patch "https://dwm.suckless.org/patches/status2d/dwm-status2d-6.4.diff"
apply_patch "https://dwm.suckless.org/patches/autostart/dwm-autostart-20210120-cb3f58a.diff"
apply_patch "https://dwm.suckless.org/patches/alpha/dwm-alpha-6.4.diff"

# Compile and install dwm
sudo make clean install
cd ..

### ST ###
echo "Cloning and patching st..."
git clone https://git.suckless.org/st
cd st || exit 1

# Apply ST patches
apply_patch "https://st.suckless.org/patches/scrollback/st-scrollback-0.8.5.diff"
apply_patch "https://st.suckless.org/patches/alpha/st-alpha-0.8.5.diff"
apply_patch "https://st.suckless.org/patches/ligatures/st-ligatures-20220310.diff"

# Compile and install st
sudo make clean install
cd ..

### DMENU ###
echo "Cloning and patching dmenu..."
git clone https://git.suckless.org/dmenu
cd dmenu || exit 1

# Apply DMENU patches
apply_patch "https://tools.suckless.org/dmenu/patches/center/dmenu-center-20200111-8cd37e1.diff"
apply_patch "https://tools.suckless.org/dmenu/patches/alpha/dmenu-alpha-20210615-2b3e7ae.diff"

# Compile and install dmenu
sudo make clean install
cd ..

echo "✅ Suckless software installed successfully!"
echo "Remember to set dwm as your X session in ~/.xinitrc or your display manager."
echo "exec dwm" > ~/.xinitrc
