#!/usr/bin/env bash

# Simple power menu inspired by Omarchy (Super+Escape)
# Requires: wofi, swaylock, systemd user privileges

set -euo pipefail

choices=(
  "Lock"
  "Suspend"
  "Relaunch Hyprland"
  "Restart"
  "Shutdown"
)

choice=$(printf '%s\n' "${choices[@]}" | wofi --dmenu --prompt "Power" --cache-file /dev/null)

case "$choice" in
  "Lock")
    swaylock -f -c 000000 ;;
  "Suspend")
    swaylock -f -c 000000 && systemctl suspend ;;
  "Relaunch Hyprland")
    hyprctl dispatch exit ;;
  "Restart")
    systemctl reboot ;;
  "Shutdown")
    systemctl poweroff ;;
  *)
    exit 0 ;;
esac

