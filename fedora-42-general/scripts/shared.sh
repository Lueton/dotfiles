#!/bin/bash
set -euo pipefail
DOTFILES_DIR="${1:-$(realpath "$(dirname "$0")/..")}"
source "$DOTFILES_DIR/scripts/utils.sh" "$DOTFILES_DIR"

section "Shared Configs" "🔗"

SHARED_DIR="$(realpath "$DOTFILES_DIR/../shared")"

symlink "$SHARED_DIR/git/.gitconfig" "$HOME/.gitconfig"
symlink "$SHARED_DIR/nvim" "$HOME/.config/nvim"

log_success "Shared configs linked"
