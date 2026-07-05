#!/bin/bash
# Reports the number of pending dnf5 updates as a Waybar custom-module JSON payload.
set -euo pipefail

RESULT="$(timeout 25 dnf5 -q check-update --json 2>/dev/null || echo '{"upgrades":[]}')"
COUNT="$(jq '.upgrades | length' <<<"$RESULT" 2>/dev/null || echo 0)"

if [ "$COUNT" -eq 0 ]; then
    jq -nc '{text: "", tooltip: "System up to date", class: "idle"}'
else
    NAMES="$(jq -r '.upgrades[:12] | map(.name) | join("\n")' <<<"$RESULT")"
    MORE=$(( COUNT > 12 ? COUNT - 12 : 0 ))
    TOOLTIP="$COUNT update(s) available:"$'\n'"$NAMES"
    [ "$MORE" -gt 0 ] && TOOLTIP="$TOOLTIP"$'\n'"… and $MORE more"
    jq -nc --arg text "󰦘 $COUNT" --arg tooltip "$TOOLTIP" \
        '{text: $text, tooltip: $tooltip, class: "pending"}'
fi
