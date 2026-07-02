#!/bin/bash
set -euo pipefail
DOTFILES_DIR="${1:-$(realpath "$(dirname "$0")/..")}"
source "$DOTFILES_DIR/scripts/utils.sh" "$DOTFILES_DIR"

section "Window Manager Stack" "🪟"

log_info "Installing Sway, Waybar, Mako, Wofi..."
sudo dnf install -y sway swaybg swaylock swayidle waybar mako wofi grim slurp wl-clipboard nemo

log_info "Installing KDE Plasma (fallback session)..."
sudo dnf group install -y "kde-desktop-environment"

log_info "Installing SDDM..."
sudo dnf install -y sddm
sudo systemctl enable sddm.service

# Sway has no generated files inside its config dir, so the whole directory can be symlinked
symlink "$DOTFILES_DIR/config/sway" "$HOME/.config/sway"

# Waybar/Wofi: symlink files individually, not the whole dir — each also gets a
# colors-*.css symlink into ~/.cache/wal, which must not land inside the git repo
mkdir -p "$HOME/.config/waybar"
symlink "$DOTFILES_DIR/config/waybar/config.jsonc" "$HOME/.config/waybar/config.jsonc"
symlink "$DOTFILES_DIR/config/waybar/style.css"    "$HOME/.config/waybar/style.css"
ln -sf "$HOME/.cache/wal/colors-waybar.css" "$HOME/.config/waybar/colors-waybar.css"

mkdir -p "$HOME/.config/wofi"
symlink "$DOTFILES_DIR/config/wofi/config"    "$HOME/.config/wofi/config"
symlink "$DOTFILES_DIR/config/wofi/style.css" "$HOME/.config/wofi/style.css"
ln -sf "$HOME/.cache/wal/colors-wofi.css" "$HOME/.config/wofi/colors-wofi.css"

# Mako is not symlinked — pywal regenerates ~/.config/mako/config on each 'wallpaper' call
# copy static fallback for first boot (before any wallpaper is set)
mkdir -p "$HOME/.config/mako"
if [ ! -f "$HOME/.config/mako/config" ]; then
    cp "$DOTFILES_DIR/config/mako/config" "$HOME/.config/mako/config"
fi

# Only set the default session if no login has happened yet, so a rerun never
# overwrites a session the user picked manually afterwards
AS_USER_FILE="/var/lib/AccountsService/users/${USER}"
if [ ! -f "$AS_USER_FILE" ]; then
    sudo tee "$AS_USER_FILE" > /dev/null <<EOF
[User]
Session=sway.desktop
EOF
fi

log_success "WM setup complete"
