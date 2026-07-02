#!/bin/bash
set -euo pipefail
DOTFILES_DIR="${1:-$(realpath "$(dirname "$0")/..")}"
source "$DOTFILES_DIR/scripts/utils.sh" "$DOTFILES_DIR"

section "Terminal" "🖥️"

if ! is_installed kitty; then
    log_info "Installing kitty via official installer..."
    curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin launch=n
    mkdir -p "$HOME/.local/bin"
    ln -sf "$HOME/.local/kitty.app/bin/kitty"  "$HOME/.local/bin/kitty"
    ln -sf "$HOME/.local/kitty.app/bin/kitten" "$HOME/.local/bin/kitten"
    # Desktop entry
    cp -f "$HOME/.local/kitty.app/share/applications/kitty.desktop" \
          "$HOME/.local/share/applications/" 2>/dev/null || true
fi

symlink "$DOTFILES_DIR/config/kitty" "$HOME/.config/kitty"

log_success "Kitty setup complete"
