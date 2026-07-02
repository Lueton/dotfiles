#!/bin/bash
set -euo pipefail
DOTFILES_DIR="${1:-$(realpath "$(dirname "$0")/..")}"
source "$DOTFILES_DIR/scripts/utils.sh" "$DOTFILES_DIR"

section "Container Runtime" "🐳"

log_info "Installing Podman, podman-compose, podman-docker (docker CLI compat), podman-tui..."
sudo dnf install -y podman podman-compose podman-docker podman-tui

log_info "Enabling rootless Podman API socket (Docker-API-compatible, for tools that need a real socket, not just the CLI)..."
systemctl --user enable --now podman.socket

log_success "Container runtime setup complete — 'docker' commands now run via Podman"
