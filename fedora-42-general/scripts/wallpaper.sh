#!/bin/bash
# Set the desktop wallpaper image (does not touch the color theme — see apply-theme.sh)
set -euo pipefail

B_GREEN='\033[1;32m'
B_RED='\033[1;31m'
B_CYAN='\033[1;36m'
B_WHITE='\033[1;37m'
DIM='\033[2m'
BOLD='\033[1m'
NC='\033[0m'

WALLPAPER="${1:-}"

if [ -z "$WALLPAPER" ]; then
    echo -e "  ${B_RED}✗${NC}  Usage: wallpaper <image-path>"
    exit 1
fi

if [ ! -f "$WALLPAPER" ]; then
    echo -e "  ${B_RED}✗${NC}  File not found: $WALLPAPER"
    exit 1
fi

WALLPAPER="$(realpath "$WALLPAPER")"

echo ""
echo -e "${B_CYAN}  ╭─────────────────────────────────────────────${NC}"
echo -e "${B_CYAN}  │${NC}  🖼️  ${BOLD}${B_WHITE}Setting Wallpaper${NC}"
echo -e "${B_CYAN}  ╰─────────────────────────────────────────────${NC}"
echo ""
echo -e "     ${DIM}·  $WALLPAPER${NC}"
echo ""

# swaybg has no live-reload — kill and relaunch with the new wallpaper
ln -sf "$WALLPAPER" "$HOME/wallpapers/current"
pkill swaybg 2>/dev/null || true
swaybg -i "$WALLPAPER" -m fill & disown
echo -e "  ${B_GREEN}✓${NC}  wallpaper set"

echo ""
