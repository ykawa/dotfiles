#!/usr/bin/env bash

# Control notifications (mako) similar to Omarchy bindings
# Requires: makoctl

set -euo pipefail

cmd=${1:-}

case "$cmd" in
  latest|close|dismiss)
    makoctl dismiss ;;
  all)
    makoctl dismiss -a ;;
  toggle)
    # Toggle a 'dnd' mode; effective if configured in mako
    makoctl mode -t dnd || true ;;
  *)
    echo "Usage: $0 {latest|all|toggle}" >&2
    exit 2 ;;
esac

