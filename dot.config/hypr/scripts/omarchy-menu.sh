#!/usr/bin/env bash

# Omarchy-like control menu (Super+Alt+Space)
# Offers quick toggles and actions

set -euo pipefail

menu_items=(
  "  Lock | lock"
  "  Suspend | suspend"
  "󰍹  Next Background | nextbg"
  "󰖔  Toggle Nightlight | nightlight"
  "󰥰  Toggle Idle | idle"
  "󰖔  Toggle Top Bar | bar"
  "󰗼  Relaunch Hyprland | relaunch"
  "󰜉  Restart | reboot"
  "⏻  Shutdown | poweroff"
)

choice=$(printf '%s\n' "${menu_items[@]}" | cut -d'|' -f1 | wofi --dmenu --prompt "Omarchy" --cache-file /dev/null)
action=$(printf '%s' "$choice" | awk -F'\|' '{gsub(/^ *| *$/,"",$2); print $2}')

case "$action" in
  lock)
    swaylock -f -c 000000 ;;
  suspend)
    swaylock -f -c 000000 && systemctl suspend ;;
  nextbg)
    bash -lc "~/.config/hypr/scripts/wallpaper-next.sh" ;;
  nightlight)
    bash -lc "~/.config/hypr/scripts/nightlight-toggle.sh" ;;
  idle)
    bash -lc "~/.config/hypr/scripts/idle-toggle.sh" ;;
  bar)
    bash -lc "~/.config/hypr/scripts/waybar-toggle.sh" ;;
  relaunch)
    hyprctl dispatch exit ;;
  reboot)
    systemctl reboot ;;
  poweroff)
    systemctl poweroff ;;
  *)
    exit 0 ;;
esac

