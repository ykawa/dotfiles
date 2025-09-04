#!/usr/bin/env bash

# Toggle Waybar visibility (Omarchy: Shift+Super+Space)

set -euo pipefail

if pgrep -x waybar >/dev/null; then
  killall waybar || true
else
  waybar -c ~/.config/waybar/config.jsonc -s ~/.config/waybar/style.css & disown
fi

