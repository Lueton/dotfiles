#!/bin/bash
# Bootstrap: install git, clone repo, run make
set -euo pipefail

REPO_URL="https://github.com/lueton/dotfiles"
DOTFILES_DIR="$HOME/.dotfiles"

B_MAGENTA='\033[1;35m'
B_WHITE='\033[1;37m'
B_RED='\033[1;31m'
BOLD='\033[1m'
DIM='\033[2m'
NC='\033[0m'

echo ""
echo -e "${B_MAGENTA}  ╭────────────────────────────────────────────────${NC}"
echo -e "${B_MAGENTA}  │${NC}  🚀  ${BOLD}${B_WHITE}Lueton's Dotfiles${NC}"
echo -e "${B_MAGENTA}  │${NC}  ${DIM}Linux Mint  ·  i3  ·  Kitty  ·  Starship${NC}"
echo -e "${B_MAGENTA}  ╰────────────────────────────────────────────────${NC}"
echo ""

if [[ "$(uname)" != "Linux" ]]; then
    echo -e "  ${B_RED}✗${NC}  This script is for Linux only."
    exit 1
fi

if ! command -v git &>/dev/null || ! command -v make &>/dev/null; then
    sudo apt update && sudo apt install -y git make
fi

if [ ! -d "$DOTFILES_DIR" ]; then
    git clone "$REPO_URL" "$DOTFILES_DIR"
fi

cd "$DOTFILES_DIR"
make all
