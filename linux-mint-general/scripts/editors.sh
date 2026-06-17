#!/bin/bash
set -euo pipefail
DOTFILES_DIR="${1:-$(realpath "$(dirname "$0")/..")}"
source "$DOTFILES_DIR/scripts/utils.sh" "$DOTFILES_DIR"

section "Editors" "✏️"

# VS Code
if ! is_installed code; then
    log_info "🟦  Installing VS Code..."
    curl -fsSL https://packages.microsoft.com/keys/microsoft.asc \
        | gpg --dearmor | sudo tee /usr/share/keyrings/microsoft.gpg > /dev/null
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft.gpg] \
https://packages.microsoft.com/repos/code stable main" \
        | sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null
    sudo apt update
    sudo apt install -y code
fi

# Zed
if ! is_installed zed; then
    log_info "⚡  Installing Zed..."
    curl -f https://zed.dev/install.sh | sh
fi

# JetBrains Toolbox
TOOLBOX_BIN="$HOME/.local/share/JetBrains/Toolbox/bin/jetbrains-toolbox"
if [ ! -f "$TOOLBOX_BIN" ]; then
    log_info "🧰  Installing JetBrains Toolbox..."
    TOOLBOX_VERSION="2.3.2.31487"
    local_tmp=$(mktemp -d)
    curl -fL "https://download.jetbrains.com/toolbox/jetbrains-toolbox-${TOOLBOX_VERSION}.tar.gz" \
        -o "$local_tmp/toolbox.tar.gz"
    tar -xzf "$local_tmp/toolbox.tar.gz" -C "$local_tmp"
    mkdir -p "$(dirname "$TOOLBOX_BIN")"
    cp "$local_tmp"/jetbrains-toolbox-*/jetbrains-toolbox "$TOOLBOX_BIN"
    rm -rf "$local_tmp"
    "$TOOLBOX_BIN" &
    log_warn "JetBrains Toolbox launched — complete the installation in the UI"
fi

log_success "Editors setup complete"
