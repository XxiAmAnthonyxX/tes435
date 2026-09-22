#!/usr/bin/env bash
set -euo pipefail

# Dhcpcd
sudo systemctl enable --now dhcpcd.service

# Firewall
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw enable

# Pacman
sudo reflector --verbose --country 'United States' --age 12 --protocol https --sort rate --fastest 10 --save /etc/pacman.d/mirrorlist
sudo pacman -Syu

# Yay
git clone https://aur.archlinux.org/yay.git
cd yay && makepkg -si
cd .. && rm -rf yay

# Official Packages
sudo pacman -S hyprland xdg-desktop-portal-hyprland hyprpolkitagent hyprlock hyprshot xdg-utils qt6-wayland waybar \
  pipewire wireplumber pipewire-pulse pipewire-alsa lib32-pipewire lib32-libpulse wiremix cava \
  capitaine-cursors ttf-jetbrains-mono-nerd noto-fonts noto-fonts-cjk noto-fonts-emoji \
  kitty fish starship fastfetch \
  eza bat fd sd ripgrep fzf zoxide atuin 7zip unarchiver trash-cli \
  yazi imv mpv ffmpeg udiskie \
  btop rocm-smi-lib \
  cliphist wl-clipboard wl-clip-persist \
  steam mesa vulkan-radeon lib32-mesa lib32-vulkan-radeon \
  librewolf

# AUR Packages
Yay -S python-pywal16 python-pywalfox mpvpaper xdg-desktop-portal-termfilechooser-hunkyburrito-git

# Configs
cp -r /mnt/backup/DOTS/{atuin,btop,cava,fastfetch,fish,hypr,kitty,nvim,starship,wal,waybar,xdg-desktop-portal,xdg-desktop-portal-termfilechooser,yazi,mimeapps.list} ~/.config/
cp -r /mnt/backup/DOTS/{yazi.desktop} ~/.local/share/applications/

# Shell
chsh -s /usr/bin/fish

# Yazi
update-desktop-database ~/.local/share/applications

# Reboot
sudo systemctl reboot
