#!/bin/bash
# Set wallpaper and regenerate pywal color scheme across the whole desktop
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
echo -e "${B_CYAN}  │${NC}  🖼️  ${BOLD}${B_WHITE}Applying Wallpaper & Color Scheme${NC}"
echo -e "${B_CYAN}  ╰─────────────────────────────────────────────${NC}"
echo ""
echo -e "     ${DIM}·  $WALLPAPER${NC}"
echo ""

# pywal has no Wayland wallpaper backend — skip it, swaybg is managed explicitly below
wal -i "$WALLPAPER" -n

# Reload sway colors without restarting
pgrep -x sway > /dev/null && swaymsg reload
echo -e "  ${B_GREEN}✓${NC}  sway colors reloaded"

# Reload kitty colors (SIGUSR1 triggers config reload)
pkill -SIGUSR1 kitty 2>/dev/null || true
echo -e "  ${B_GREEN}✓${NC}  kitty colors reloaded"

# Waybar reloads its CSS live via SIGUSR2 — no relaunch needed
pkill -SIGUSR2 waybar 2>/dev/null || true
echo -e "  ${B_GREEN}✓${NC}  waybar colors reloaded"

# Regenerate mako config (no confirmed 'include=' support) and reload
mkdir -p "$HOME/.config/mako"
cp "$HOME/.cache/wal/mako" "$HOME/.config/mako/config"
makoctl reload 2>/dev/null || (mako &)
echo -e "  ${B_GREEN}✓${NC}  mako reloaded"

# Regenerate hyprlock config (hyprlock reads config fresh on each launch — no reload needed)
mkdir -p "$HOME/.config/hypr"
cp "$HOME/.cache/wal/hyprlock.conf" "$HOME/.config/hypr/hyprlock.conf"
echo -e "  ${B_GREEN}✓${NC}  hyprlock colors updated"

# wofi has no reload code, reads its colors live from ~/.cache/wal on next launch

# swaybg has no live-reload — kill and relaunch with the new wallpaper
ln -sf "$WALLPAPER" "$HOME/wallpapers/current"
pkill swaybg 2>/dev/null || true
swaybg -i "$WALLPAPER" -m fill & disown
echo -e "  ${B_GREEN}✓${NC}  wallpaper set"

echo ""
echo -e "  🎨  Color scheme applied from: ${DIM}$WALLPAPER${NC}"
echo ""
