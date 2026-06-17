#!/bin/bash
# Relaunch polybar — called on i3 reload and by 'wallpaper' command

killall -q polybar || true
while pgrep -u "$UID" -x polybar >/dev/null; do sleep 0.2; done

polybar main 2>&1 | tee -a /tmp/polybar.log & disown
