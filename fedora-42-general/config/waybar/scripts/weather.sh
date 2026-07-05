#!/bin/bash
# Fixed-city (Berlin) weather via wttr.in for custom/weather.
# Uses a local condition-text -> Nerd Font icon mapping instead of wttr.in's
# built-in emoji (%c), which isn't covered by JetBrainsMono Nerd Font and
# falls back to a wider system emoji font, plus bakes in its own extra space.
set -euo pipefail

CITY="Berlin"

RAW="$(curl -s --max-time 5 "wttr.in/${CITY}?format=%C|%t" || true)"

if [ -z "$RAW" ]; then
    jq -nc '{text: "󰼶 --", tooltip: "Weather unavailable", class: "error"}'
    exit 0
fi

CONDITION="${RAW%%|*}"
TEMP="$(echo "${RAW#*|}" | tr -d '[:space:]')"

COND_LC="$(echo "$CONDITION" | tr '[:upper:]' '[:lower:]')"
case "$COND_LC" in
    *thunder*)                    ICON="󰙾" ;;
    *snow*|*sleet*|*blizzard*)    ICON="󰼶" ;;
    *rain*|*drizzle*|*shower*)    ICON="󰖗" ;;
    *fog*|*mist*|*haze*)          ICON="󰖑" ;;
    *cloud*|*overcast*)           ICON="󰖐" ;;
    *clear*|*sunny*)               ICON="󰖙" ;;
    *)                             ICON="󰖐" ;;
esac

TEXT="$ICON $TEMP"

TEMP_NUM="$(echo "$TEMP" | grep -oE '\-?[0-9]+' | head -1)"
CLASS="ok"
if [ -n "$TEMP_NUM" ]; then
    if [ "$TEMP_NUM" -ge 35 ]; then
        CLASS="critical"
    elif [ "$TEMP_NUM" -ge 30 ]; then
        CLASS="warning"
    fi
fi

TOOLTIP="$(curl -s --max-time 5 "wttr.in/${CITY}?format=%l:+%C,+%t+(feels+%f)%0A%h+humidity,+%w+wind%0A%p+precipitation" || echo "$TEXT")"

jq -nc --arg text "$TEXT" --arg tooltip "$TOOLTIP" --arg class "$CLASS" \
    '{text: $text, tooltip: $tooltip, class: $class}'
