#!/bin/bash
set -euo pipefail
DOTFILES_DIR="${1:-$(realpath "$(dirname "$0")/..")}"
source "$DOTFILES_DIR/scripts/utils.sh" "$DOTFILES_DIR"

section "Window Manager Stack" "🪟"

log_info "Installing i3, polybar, rofi, picom, dunst..."
sudo apt install -y i3 polybar rofi dunst feh picom xorg dex xss-lock

# Dynamic workspace icons daemon
if ! is_installed i3-workspace-names-daemon; then
    log_info "Installing i3-workspace-names-daemon..."
    pip3 install --user i3-workspace-names-daemon
fi

# Symlink all WM configs
symlink "$DOTFILES_DIR/config/i3"      "$HOME/.config/i3"
symlink "$DOTFILES_DIR/config/polybar" "$HOME/.config/polybar"
symlink "$DOTFILES_DIR/config/rofi"   "$HOME/.config/rofi"
symlink "$DOTFILES_DIR/config/picom"  "$HOME/.config/picom"

# dunst is not symlinked — pywal generates ~/.config/dunst/dunstrc on each 'wallpaper' call
# copy static fallback for first boot (before any wallpaper is set)
mkdir -p "$HOME/.config/dunst"
if [ ! -f "$HOME/.config/dunst/dunstrc" ]; then
    cp "$DOTFILES_DIR/config/dunst/dunstrc" "$HOME/.config/dunst/dunstrc"
fi

chmod +x "$DOTFILES_DIR/config/polybar/launch.sh"

log_success "WM setup complete"
