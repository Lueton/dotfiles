#!/bin/bash
set -euo pipefail
DOTFILES_DIR="${1:-$(realpath "$(dirname "$0")/..")}"
source "$DOTFILES_DIR/scripts/utils.sh" "$DOTFILES_DIR"

section "Shell Setup" "🐚"

# zsh
if ! is_installed zsh; then
    sudo dnf install -y zsh
fi

# Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    log_info "Installing Oh My Zsh..."
    RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

clone_if_missing() {
    local name="$1" url="$2" dest="$3"
    if [ ! -d "$dest" ]; then
        log_info "Installing $name..."
        git clone "$url" "$dest"
    fi
}

clone_if_missing "zsh-autosuggestions" \
    "https://github.com/zsh-users/zsh-autosuggestions" \
    "$ZSH_CUSTOM/plugins/zsh-autosuggestions"

clone_if_missing "zsh-syntax-highlighting" \
    "https://github.com/zsh-users/zsh-syntax-highlighting" \
    "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

clone_if_missing "zsh-z" \
    "https://github.com/agkozak/zsh-z" \
    "$ZSH_CUSTOM/plugins/zsh-z"

# Starship prompt
if ! is_installed starship; then
    log_info "Installing Starship prompt..."
    curl -sS https://starship.rs/install.sh | sh -s -- --yes
fi

# Symlinks
symlink "$DOTFILES_DIR/config/zsh/.zshrc"  "$HOME/.zshrc"
symlink "$DOTFILES_DIR/config/zsh/.zprofile" "$HOME/.zprofile"
symlink "$DOTFILES_DIR/config/starship/starship.toml" "$HOME/.config/starship/starship.toml"

# Default shell
if [ "$SHELL" != "$(command -v zsh)" ]; then
    log_info "Setting zsh as default shell..."
    chsh -s "$(command -v zsh)"
fi

log_success "Shell setup complete"
