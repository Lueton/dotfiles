#!/bin/bash
set -euo pipefail
DOTFILES_DIR="${1:-$(realpath "$(dirname "$0")/..")}"
source "$DOTFILES_DIR/scripts/utils.sh" "$DOTFILES_DIR"

section "Theming & Color Schemes" "🎨"

# pywal
if ! is_installed wal; then
    log_info "Installing pywal..."
    if ! is_installed pipx; then
        sudo apt install -y pipx
        pipx ensurepath
    fi
    pipx install pywal
    pipx inject pywal haishoku
    export PATH="$HOME/.local/bin:$PATH"
fi

# pywal templates
mkdir -p "$HOME/.config/wal"
symlink "$DOTFILES_DIR/config/pywal/templates" "$HOME/.config/wal/templates"

# Wallpapers directory
symlink "$DOTFILES_DIR/wallpapers" "$HOME/wallpapers"

# wallpaper helper script
symlink "$DOTFILES_DIR/scripts/wallpaper.sh" "$HOME/.local/bin/wallpaper"
chmod +x "$DOTFILES_DIR/scripts/wallpaper.sh"

# Generate initial color scheme
DEFAULT_WALLPAPER="$HOME/wallpapers/lunar-tides.jpg"
if [ -f "$DEFAULT_WALLPAPER" ]; then
    log_info "Generating initial color scheme from lunar-tides.jpg..."
    wal -i "$DEFAULT_WALLPAPER" --backend haishoku -q
    log_success "Initial color scheme generated"
else
    log_warn "Color scheme not yet generated — do this before starting i3:"
    log_info "  wallpaper ~/wallpapers/your-image.jpg"
fi

log_success "Theming setup complete"
