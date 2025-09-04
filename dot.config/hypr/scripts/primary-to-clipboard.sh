#!/usr/bin/env bash
set -euo pipefail

# Sync PRIMARY selection to CLIPBOARD on Wayland (X11-like select-to-copy).
# Requires: wl-clipboard (wl-paste, wl-copy)

wl-paste --type text --primary --watch 'wl-copy --type text --no-persist'

