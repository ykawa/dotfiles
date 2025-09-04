#!/usr/bin/env bash

# Toggle idle/sleep prevention by starting/stopping swayidle
# Mirrors Omarchy: Ctrl+Super+I

set -euo pipefail

if pgrep -x swayidle >/dev/null; then
  pkill -x swayidle || true
  notify-send "Idle" "Idle enabled (swayidle stopped)" || true
else
  # Start the same idle handler as autostart
  (swayidle -w \
    timeout 300 'swaylock -f -c 000000' \
    before-sleep 'swaylock -f -c 000000') & disown
  notify-send "Idle" "Idle disabled (swayidle running)" || true
fi

