#!/bin/bash
set -euo pipefail
DOTFILES_DIR="${1:-$(realpath "$(dirname "$0")/..")}"
source "$DOTFILES_DIR/scripts/utils.sh" "$DOTFILES_DIR"

section "SSH Access" "🔐"

if ! rpm -q openssh-server &>/dev/null; then
    log_info "Installing openssh-server..."
    sudo dnf install -y openssh-server
fi

SSH_KEY="$HOME/.ssh/id_ed25519_workstation"
if [ ! -f "$SSH_KEY" ]; then
    log_info "🔑  Generating SSH keypair ($SSH_KEY)..."
    mkdir -p "$HOME/.ssh"
    chmod 700 "$HOME/.ssh"
    ssh-keygen -t ed25519 -f "$SSH_KEY" -N "" -C "$(whoami)@$(hostname)-workstation"
    log_success "SSH keypair generated"
else
    log_info "SSH keypair already exists, skipping generation"
fi

touch "$HOME/.ssh/authorized_keys"
chmod 600 "$HOME/.ssh/authorized_keys"
if ! grep -qF "$(cat "${SSH_KEY}.pub")" "$HOME/.ssh/authorized_keys"; then
    cat "${SSH_KEY}.pub" >> "$HOME/.ssh/authorized_keys"
    log_success "Public key added to authorized_keys"
else
    log_info "Public key already present in authorized_keys, skipping"
fi

SSHD_DROPIN="/etc/ssh/sshd_config.d/99-key-only.conf"
if [ ! -f "$SSHD_DROPIN" ]; then
    log_info "Hardening sshd (key-only authentication)..."
    sudo tee "$SSHD_DROPIN" > /dev/null <<'EOF'
PasswordAuthentication no
KbdInteractiveAuthentication no
PubkeyAuthentication yes
PermitRootLogin no
EOF
fi

sudo systemctl enable --now sshd
sudo systemctl reload sshd

if command -v firewall-cmd &>/dev/null && ! firewall-cmd --query-service=ssh &>/dev/null; then
    log_info "Opening ssh service in firewalld..."
    sudo firewall-cmd --add-service=ssh --permanent
    sudo firewall-cmd --reload
fi

log_success "SSH server enabled — key-only authentication"
log_warn "Private key at $SSH_KEY was generated locally and is NOT part of the repo. Copy it to any client that needs to connect in, e.g.: scp $SSH_KEY <client>:~/.ssh/"
