#!/bin/bash
# Searchable cheat sheet of configured keybindings (sway + other apps)
set -euo pipefail

SWAY_CONFIG="$HOME/.config/sway/config"
EXTRA_FILE="$HOME/.config/sway/keybinds-extra.txt"

{
    echo "== Sway =="
    grep -E '^bindsym ' "$SWAY_CONFIG" | sed -E 's/^bindsym\s+(\S+)\s+/\1    /'

    echo ""
    echo "== Sway (resize mode, mod+r) =="
    grep -E '^\s+bindsym ' "$SWAY_CONFIG" | sed -E 's/^\s+bindsym\s+(\S+)\s+/\1    /'

    if [ -f "$EXTRA_FILE" ]; then
        echo ""
        cat "$EXTRA_FILE"
    fi
} | wofi --show dmenu --prompt "Keybinds" --lines 25 --width 700 > /dev/null
