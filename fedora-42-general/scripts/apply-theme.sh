#!/bin/bash
# Apply a static pywal color theme across the whole desktop (independent of the wallpaper image)
set -euo pipefail

B_GREEN='\033[1;32m'
B_RED='\033[1;31m'
B_CYAN='\033[1;36m'
B_WHITE='\033[1;37m'
DIM='\033[2m'
BOLD='\033[1m'
NC='\033[0m'

THEME="${1:-tailwind-dark}"

echo ""
echo -e "${B_CYAN}  ╭─────────────────────────────────────────────${NC}"
echo -e "${B_CYAN}  │${NC}  🎨  ${BOLD}${B_WHITE}Applying Color Theme${NC}"
echo -e "${B_CYAN}  ╰─────────────────────────────────────────────${NC}"
echo ""
echo -e "     ${DIM}·  $THEME${NC}"
echo ""

# Renders the theme (fixed palette, no image extraction) into ~/.cache/wal/
wal --theme "$THEME" -n

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

# Regenerate swaylock config (swaylock reads config fresh on each launch — no reload needed)
mkdir -p "$HOME/.config/swaylock"
cp "$HOME/.cache/wal/swaylock" "$HOME/.config/swaylock/config"
echo -e "  ${B_GREEN}✓${NC}  swaylock colors updated"

# wofi has no reload code, reads its colors live from ~/.cache/wal on next launch

echo ""
echo -e "  🎨  Color theme applied: ${DIM}$THEME${NC}"
echo ""
