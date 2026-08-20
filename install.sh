#!/bin/sh
# DDD framework installer shim — forwards to the authoritative scripts/install.sh.
# Usage: ./install.sh [same flags as scripts/install.sh --help]

set -u

# Resolve the directory containing this shim, robust to spaces.
SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" 2>/dev/null && pwd)
AUTHORITATIVE="$SCRIPT_DIR/scripts/install.sh"

if [ ! -f "$AUTHORITATIVE" ]; then
    printf '%s\n' "ERROR: $AUTHORITATIVE not found; run from the distribution root." >&2
    exit 1
fi

exec sh "$AUTHORITATIVE" "$@"
