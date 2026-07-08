#!/bin/bash
# Prüft den aktuellen Sonnenstand und schaltet das GTK/Portal color-scheme
# (Firefox "Automatisch" + andere GTK-Apps) zwischen hell und dunkel um.
set -euo pipefail

# Grobe, öffentlich unbedenkliche Koordinaten (Berlin Alexanderplatz) statt exakter
# Heimkoordinaten, da dieses Dotfiles-Repo öffentlich auf GitHub liegt.
LAT="52.5219N"
# Das Fedora-Paket ist die alte sunwait-Version (2004, kein "poll"-Modus). Sie kennt für
# Längengrade nur den Suffix "W" — östliche Längen müssen als *negatives* W angegeben werden.
LON="-13.4132W"

REPORT="$(sunwait -p "$LAT" "$LON")"
RISE="$(grep -oP 'Sun rises \K[0-9]{4}' <<< "$REPORT")"
SET="$(grep -oP 'sets \K[0-9]{4}' <<< "$REPORT")"

if [ -z "$RISE" ] || [ -z "$SET" ]; then
    echo "sunwait-Ausgabe konnte nicht geparst werden:" >&2
    echo "$REPORT" >&2
    exit 1
fi

NOW="$(date +%H%M)"
if (( 10#$NOW >= 10#$RISE && 10#$NOW < 10#$SET )); then
    DESIRED="prefer-light"   # zwischen Sonnenauf- und -untergang
else
    DESIRED="prefer-dark"    # Nacht
fi

CURRENT="$(gsettings get org.gnome.desktop.interface color-scheme | tr -d "'")"
if [ "$CURRENT" != "$DESIRED" ]; then
    gsettings set org.gnome.desktop.interface color-scheme "$DESIRED"
    echo "color-scheme: $CURRENT → $DESIRED"
fi

# Idee für später: sobald ein helles pywal-Farbschema existiert
# (config/pywal/colorschemes/*.json), hier zusätzlich `apply-theme <scheme>` aufrufen,
# um Sway/Waybar/Mako/Kitty synchron mit Tag/Nacht umzuschalten statt nur GTK/Firefox.
