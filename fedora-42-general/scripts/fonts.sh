#!/bin/bash
set -euo pipefail
DOTFILES_DIR="${1:-$(realpath "$(dirname "$0")/..")}"
source "$DOTFILES_DIR/scripts/utils.sh" "$DOTFILES_DIR"

section "Nerd Fonts" "🔤"

FONT_DIR="$HOME/.local/share/fonts"
NERD_FONTS_VERSION="3.4.0"

install_nerd_font() {
    local name="$1"
    local dest="$FONT_DIR/NerdFonts/$name"

    if [ -d "$dest" ]; then
        log_info "$name Nerd Font already installed, skipping"
        return
    fi

    log_info "Installing $name Nerd Font..."
    local tmp="/tmp/${name}.zip"
    curl -fLo "$tmp" \
        "https://github.com/ryanoasis/nerd-fonts/releases/download/v${NERD_FONTS_VERSION}/${name}.zip"
    mkdir -p "$dest"
    unzip -o "$tmp" -d "$dest" '*.ttf' '*.otf' 2>/dev/null || unzip -o "$tmp" -d "$dest"
    rm "$tmp"
    log_success "$name Nerd Font installed"
}

mkdir -p "$FONT_DIR/NerdFonts"

install_nerd_font "JetBrainsMono"
install_nerd_font "FiraCode"

log_info "Rebuilding font cache..."
fc-cache -fv

log_success "Fonts ready"
