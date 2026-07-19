#!/bin/bash
set -euo pipefail
DOTFILES_DIR="${1:-$(realpath "$(dirname "$0")/..")}"
source "$DOTFILES_DIR/scripts/utils.sh" "$DOTFILES_DIR"

section "Editors" "✏️"

# VS Code
if ! is_installed code; then
    log_info "🟦  Installing VS Code..."
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    if [ ! -f /etc/yum.repos.d/vscode.repo ]; then
        echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" \
            | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null
    fi
    sudo dnf check-update || true
    sudo dnf install -y code
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
    TOOLBOX_VERSION="3.6.0.85549"
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

# Claude Code
if ! is_installed claude; then
    log_info "🤖  Installing Claude Code..."
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    npm install -g @anthropic-ai/claude-code
fi

# Codex CLI
if ! is_installed codex; then
    log_info "🤖  Installing Codex CLI..."
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    npm install -g @openai/codex
fi

# DBeaver Community
if ! flatpak list --app | grep -q "io.dbeaver.DBeaverCommunity"; then
    log_info "🗄️  Installing DBeaver Community..."
    flatpak install -y flathub io.dbeaver.DBeaverCommunity
fi

# 1Password
if ! is_installed 1password; then
    log_info "🔑  Installing 1Password..."
    sudo rpm --import https://downloads.1password.com/linux/keys/1password.asc
    if [ ! -f /etc/yum.repos.d/1password.repo ]; then
        sudo tee /etc/yum.repos.d/1password.repo > /dev/null <<EOF
[1password]
name=1Password Stable Channel
baseurl=https://downloads.1password.com/linux/rpm/stable/x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://downloads.1password.com/linux/keys/1password.asc
EOF
    fi
    sudo dnf install -y 1password 1password-cli
fi

log_success "Editors setup complete"
