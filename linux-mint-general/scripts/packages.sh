#!/bin/bash
set -euo pipefail
DOTFILES_DIR="${1:-$(realpath "$(dirname "$0")/..")}"
source "$DOTFILES_DIR/scripts/utils.sh" "$DOTFILES_DIR"

section "System Packages" "📦"
log_info "Updating package index..."
sudo apt update

PACKAGES=(
    # Build essentials
    build-essential cmake pkg-config
    # Core utilities
    curl wget git unzip zip tar gzip ca-certificates gnupg
    # Shell
    zsh
    # X11 / display
    xorg xinit xclip xdotool dex xss-lock
    # WM stack
    i3 i3status rofi dunst feh picom
    # Terminal (fallback; kitty also installed via official installer)
    kitty
    # Status bar
    polybar
    # Notifications
    libnotify-bin
    # System tools
    htop btop neofetch tmux scrot brightnessctl
    # Modern CLI replacements
    ripgrep fd-find bat
    # Fonts infrastructure
    fontconfig
    # Python (for pywal)
    python3 python3-pip python3-venv
    # pyenv build deps
    libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev \
    libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
    # Audio
    pulseaudio pulseaudio-utils pavucontrol
    # Network
    network-manager network-manager-gnome
    # GTK theming
    lxappearance papirus-icon-theme
    # Media
    mpv
)

sudo apt install -y "${PACKAGES[@]}"

log_success "Core packages installed"
