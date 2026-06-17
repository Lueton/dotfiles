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

echo ""
echo -e "${B_CYAN}  ╭─────────────────────────────────────────────${NC}"
echo -e "${B_CYAN}  │${NC}  🖼️  ${BOLD}${B_WHITE}Applying Wallpaper & Color Scheme${NC}"
echo -e "${B_CYAN}  ╰─────────────────────────────────────────────${NC}"
echo ""
echo -e "     ${DIM}·  $WALLPAPER${NC}"
echo ""

wal -i "$WALLPAPER"

# Reload i3 colors without restarting
pgrep -x i3 > /dev/null && i3-msg reload
echo -e "  ${B_GREEN}✓${NC}  i3 colors reloaded"

# Reload kitty colors (SIGUSR1 triggers config reload)
pkill -SIGUSR1 kitty 2>/dev/null || true
echo -e "  ${B_GREEN}✓${NC}  kitty colors reloaded"

# Restart polybar to pick up new colors
"$HOME/.config/polybar/launch.sh"
echo -e "  ${B_GREEN}✓${NC}  polybar restarted"

# Regenerate dunst config and reload
mkdir -p "$HOME/.config/dunst"
cp "$HOME/.cache/wal/dunstrc" "$HOME/.config/dunst/dunstrc"
pkill -SIGUSR2 dunst 2>/dev/null || (dunst &)
echo -e "  ${B_GREEN}✓${NC}  dunst reloaded"

echo ""
echo -e "  🎨  Color scheme applied from: ${DIM}$WALLPAPER${NC}"
echo ""
