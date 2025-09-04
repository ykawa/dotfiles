#!/usr/bin/env bash
set -euo pipefail

# Desired window geometry
WIDTH=${WIDTH:-1680}
HEIGHT=${HEIGHT:-1080}
CLASS_REGEX=${CLASS_REGEX:-'(?i)^mcomix'}

# Choose available MComix command
if command -v mcomix3 >/dev/null 2>&1; then
  CMD="mcomix3"
elif command -v mcomix >/dev/null 2>&1; then
  CMD="mcomix"
else
  echo "ERROR: MComix(mcomix or mcomix3) が見つかりません" >&2
  exit 1
fi

"${CMD}" "$@" & disown

# Wait until the window appears
ADDR=""
for _ in $(seq 1 120); do
  ADDR=$(hyprctl clients -j | jq -r --arg re "$CLASS_REGEX" '[.[] | select(.class|test($re))][0].address // empty')
  if [[ -n "${ADDR}" ]]; then
    break
  fi
  sleep 0.05
done

[[ -n "${ADDR}" ]] || exit 0

# Ensure floating
is_floating=$(hyprctl clients -j | jq -r --arg addr "$ADDR" '[.[]|select(.address==$addr)][0].floating')
if [[ "${is_floating}" != "true" ]]; then
  hyprctl dispatch togglefloating "address:${ADDR}" || true
fi

# Read monitor info for the window
MON_NAME=$(hyprctl clients -j | jq -r --arg addr "$ADDR" '[.[]|select(.address==$addr)][0].monitor')
MON_JSON=$(hyprctl monitors -j)
MON_INFO=$(echo "$MON_JSON" | jq -r --arg name "$MON_NAME" '[.[] | select(.name==$name or (.id|tostring)==$name)][0]')

MX=$(echo "$MON_INFO" | jq -r '.x // 0')
MY=$(echo "$MON_INFO" | jq -r '.y // 0')
MW=$(echo "$MON_INFO" | jq -r '.width')
MH=$(echo "$MON_INFO" | jq -r '.height')

# Reserved areas may be array [top,right,bottom,left] or object {top,right,bottom,left}
R_TOP=$(echo "$MON_INFO" | jq -r 'if has("reserved") then (if (.reserved|type)=="array" then .reserved[0] else .reserved.top end) else 0 end // 0')
R_RIGHT=$(echo "$MON_INFO" | jq -r 'if has("reserved") then (if (.reserved|type)=="array" then .reserved[1] else .reserved.right end) else 0 end // 0')
R_BOTTOM=$(echo "$MON_INFO" | jq -r 'if has("reserved") then (if (.reserved|type)=="array" then .reserved[2] else .reserved.bottom end) else 0 end // 0')
R_LEFT=$(echo "$MON_INFO" | jq -r 'if has("reserved") then (if (.reserved|type)=="array" then .reserved[3] else .reserved.left end) else 0 end // 0')

# Compute bottom-left position within reserved bounds
X=$(( MX + R_LEFT ))
Y=$(( MY + MH - R_BOTTOM - HEIGHT ))

# Clamp (in case HEIGHT is larger than the workspace area)
if (( Y < MY + R_TOP )); then Y=$(( MY + R_TOP )); fi
if (( X < MX + R_LEFT )); then X=$(( MX + R_LEFT )); fi

# Apply geometry
hyprctl dispatch resizewindowpixel exact "$WIDTH" "$HEIGHT" "address:${ADDR}"
hyprctl dispatch movewindowpixel exact "$X" "$Y" "address:${ADDR}"

# Re-assert after a short delay (some apps resize on init)
sleep 0.1
hyprctl dispatch resizewindowpixel exact "$WIDTH" "$HEIGHT" "address:${ADDR}" || true
hyprctl dispatch movewindowpixel exact "$X" "$Y" "address:${ADDR}" || true

