#!/bin/bash
set -euo pipefail
DOTFILES_DIR="${1:-$(realpath "$(dirname "$0")/..")}"
source "$DOTFILES_DIR/scripts/utils.sh" "$DOTFILES_DIR"

section "System Packages" "📦"

enable_rpmfusion() {
    local repo="$1"
    if ! rpm -q "rpmfusion-${repo}-release" &>/dev/null; then
        log_info "Enabling RPM Fusion ${repo}..."
        sudo dnf install -y "https://mirrors.rpmfusion.org/${repo}/fedora/rpmfusion-${repo}-release-$(rpm -E %fedora).noarch.rpm"
    else
        log_info "RPM Fusion ${repo} already enabled, skipping"
    fi
}

enable_rpmfusion free
enable_rpmfusion nonfree

if ! flatpak remote-list 2>/dev/null | grep -q '^flathub'; then
    log_info "Adding Flathub remote..."
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
else
    log_info "Flathub remote already present, skipping"
fi

log_info "Refreshing dnf cache..."
sudo dnf makecache

PACKAGES=(
    # Build essentials
    gcc gcc-c++ make cmake pkgconf-pkg-config patch
    # Core utilities
    curl wget git unzip zip tar gzip ca-certificates gnupg2
    # Shell
    zsh
    # Terminal (fallback; kitty also installed via official installer)
    kitty
    # Notifications (notify-send)
    libnotify
    # System tools
    htop btop fastfetch tmux brightnessctl
    # Modern CLI replacements
    ripgrep fd-find bat
    # Fonts infrastructure
    fontconfig
    # Python (for pywal)
    python3 python3-pip
    # pyenv build deps
    openssl-devel zlib-devel bzip2 bzip2-devel readline-devel sqlite sqlite-devel \
    ncurses-devel xz xz-devel tk-devel libxml2-devel xmlsec1-openssl-devel libffi-devel
    # Audio (PipeWire — Fedora default, replaces PulseAudio)
    pipewire pipewire-pulseaudio pipewire-utils wireplumber pavucontrol
    # Network
    NetworkManager network-manager-applet
    # GTK theming
    lxappearance papirus-icon-theme
    # Media (RPM Fusion free)
    mpv
)

sudo dnf install -y "${PACKAGES[@]}"

if ! rpm -q intel-media-driver-freeworld &>/dev/null; then
    log_info "Installing intel-media-driver-freeworld (VA-API hardware acceleration)..."
    sudo dnf install -y --allowerasing intel-media-driver-freeworld
else
    log_info "intel-media-driver-freeworld already installed, skipping"
fi

log_success "Core packages installed"
