#!/usr/bin/env bash

# Toggle night light (color temperature) using gammastep or wlsunset
# Mirrors Omarchy: Ctrl+Super+N

set -euo pipefail

if pgrep -x gammastep >/dev/null || pgrep -x wlsunset >/dev/null; then
  pkill -x gammastep || true
  pkill -x wlsunset || true
  notify-send "Nightlight" "Disabled" || true
  exit 0
fi

if command -v gammastep >/dev/null 2>&1; then
  gammastep -O 3700 & disown
  notify-send "Nightlight" "Enabled via gammastep (3700K)" || true
elif command -v wlsunset >/dev/null 2>&1; then
  wlsunset -t 3700 & disown
  notify-send "Nightlight" "Enabled via wlsunset (3700K)" || true
else
  notify-send "Nightlight" "Install gammastep or wlsunset" || true
  exit 1
fi

