#!/bin/bash
source utils.sh

print_info

if [ ! -f packages.conf ]; then
    echo "no packages found, create packages.conf"
    exit 1
fi

if ! git_installed; then
    echo "git not found, install before running"
    exit 1
fi

source packages.conf

echo "updating system"
sudo pacman -Syu --noconfirm

if ! command -v yay &> /dev/null; then
    echo "installing yay"
    sudo pacman -S --needed git base-devel --noconfirm && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si --noconfirm && cd .. && rm -rf yay
else
    echo "yay installed, continuing..."
fi

echo "installing utilities..."
install_packages "${UTIL[@]}"

echo "installing dev tools..."
install_packages "${TOOLS[@]}"

echo "installing desktop env..."
install_packages "${DTENV[@]}"

echo "installing media..."
install_packages "${MEDIA[@]}"

echo "installing fonts..."
install_packages "${FONTS[@]}"

echo "installing social..."
install_packages "${SOCIAL[@]}"

echo "updating configs..."
./configure.sh
