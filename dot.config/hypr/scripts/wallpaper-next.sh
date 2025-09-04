#!/usr/bin/env bash

# Cycle background images across all monitors using hyprpaper IPC
# Mirrors Omarchy: Ctrl+Super+Space

set -euo pipefail

images_dir="$HOME/.config/omarchy/current/backgrounds"
state_dir="${XDG_RUNTIME_DIR:-/tmp}"
list_file="$state_dir/hyprpaper_backgrounds.list"
idx_file="$state_dir/hyprpaper_backgrounds.index"

shopt -s nullglob

# Build list if missing or empty
if [[ ! -s "$list_file" ]]; then
  if [[ -d "$images_dir" ]]; then
    printf '%s\n' "$images_dir"/*.{jpg,jpeg,png,webp} 2>/dev/null | sed '/\*\./d' > "$list_file" || true
  fi
fi

# Fallback to current wallpaper from hyprpaper.conf if list empty
if [[ ! -s "$list_file" ]]; then
  # Try to use the default CachyOS wallpaper as a last resort
  echo "/usr/share/wallpapers/cachyos-wallpapers/Skyscraper.png" > "$list_file"
fi

mapfile -t images < "$list_file"
count=${#images[@]}
[[ $count -gt 0 ]] || exit 0

idx=0
if [[ -f "$idx_file" ]]; then
  read -r idx < "$idx_file" || idx=0
fi
next=$(( (idx + 1) % count ))
echo "$next" > "$idx_file"

img="${images[$next]}"

# Ensure hyprpaper IPC is on and preload the image
hyprctl hyprpaper preload "$img" >/dev/null 2>&1 || true

# Apply to all monitors
if command -v jq >/dev/null 2>&1; then
  hyprctl monitors -j | jq -r '.[].name' 2>/dev/null | while read -r mon; do
    [[ -n "$mon" ]] || continue
    hyprctl hyprpaper wallpaper "$mon,$img" >/dev/null 2>&1 || true
  done
else
  # Fallback: parse plain text output
  hyprctl monitors | awk '/Monitor/ {print $2}' | while read -r mon; do
    [[ -n "$mon" ]] || continue
    hyprctl hyprpaper wallpaper "$mon,$img" >/dev/null 2>&1 || true
  done
fi

notify-send "Wallpaper" "Set to: $(basename "$img")" || true
