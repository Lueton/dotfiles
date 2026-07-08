#!/bin/bash
set -euo pipefail
DOTFILES_DIR="${1:-$(realpath "$(dirname "$0")/..")}"
source "$DOTFILES_DIR/scripts/utils.sh" "$DOTFILES_DIR"

section "Theming & Color Schemes" "🎨"

# pywal
if ! is_installed wal; then
    log_info "Installing pywal..."
    if ! is_installed pipx; then
        sudo dnf install -y pipx
        pipx ensurepath
    fi
    pipx install pywal
    pipx inject pywal haishoku
    export PATH="$HOME/.local/bin:$PATH"
fi

# pywal templates
mkdir -p "$HOME/.config/wal"
symlink "$DOTFILES_DIR/config/pywal/templates" "$HOME/.config/wal/templates"

# Static color themes (fixed palette, independent of the wallpaper image)
for scheme in "$DOTFILES_DIR"/config/pywal/colorschemes/*.json; do
    symlink "$scheme" "$HOME/.config/wal/colorschemes/dark/$(basename "$scheme")"
done

# Wallpapers directory
symlink "$DOTFILES_DIR/wallpapers" "$HOME/wallpapers"

# wallpaper + theme helper scripts
symlink "$DOTFILES_DIR/scripts/wallpaper.sh" "$HOME/.local/bin/wallpaper"
chmod +x "$DOTFILES_DIR/scripts/wallpaper.sh"
symlink "$DOTFILES_DIR/scripts/apply-theme.sh" "$HOME/.local/bin/apply-theme"
chmod +x "$DOTFILES_DIR/scripts/apply-theme.sh"

# Apply the static color theme (does not depend on a wallpaper image existing)
log_info "Applying tailwind-dark color theme..."
bash "$DOTFILES_DIR/scripts/apply-theme.sh" tailwind-dark
log_success "Color theme applied"

# Set the default wallpaper image, if present
DEFAULT_WALLPAPER="$HOME/wallpapers/lunar-tides.jpg"
if [ -f "$DEFAULT_WALLPAPER" ]; then
    ln -sf "$DEFAULT_WALLPAPER" "$HOME/wallpapers/current"
    log_success "Default wallpaper set"
else
    log_warn "No default wallpaper found — set one before starting sway:"
    log_info "  wallpaper ~/wallpapers/your-image.jpg"
fi

# sunwait: Sonnenauf-/-untergangsberechnung für automatisches Hell/Dunkel-Umschalten
if ! is_installed sunwait; then
    log_info "Installing sunwait..."
    sudo dnf install -y sunwait
fi

symlink "$DOTFILES_DIR/scripts/sunset-theme.sh" "$HOME/.local/bin/sunset-theme"
chmod +x "$DOTFILES_DIR/scripts/sunset-theme.sh"

mkdir -p "$HOME/.config/systemd/user"
symlink "$DOTFILES_DIR/config/systemd/user/sunset-theme.service" "$HOME/.config/systemd/user/sunset-theme.service"
symlink "$DOTFILES_DIR/config/systemd/user/sunset-theme.timer" "$HOME/.config/systemd/user/sunset-theme.timer"
systemctl --user daemon-reload
systemctl --user enable --now sunset-theme.timer

log_info "Setting initial color-scheme based on current sun position..."
"$HOME/.local/bin/sunset-theme"
log_success "Sunset theme switching enabled"

log_success "Theming setup complete"
