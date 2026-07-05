#!/bin/bash
# Interactive upgrade, launched by custom/updates' on-click; refreshes the
# waybar counter immediately afterward instead of waiting for the next poll.
set -euo pipefail

sudo dnf5 upgrade
echo
read -n1 -s -r -p "Press any key to close..."
pkill -RTMIN+8 waybar 2>/dev/null || true
