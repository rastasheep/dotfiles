#!/usr/bin/env bash
#
# Keyboard Remap Apply Script
#
# Installs a per-user LaunchAgent (see keyboard-remaps.nix) that re-applies
# a hidutil keyboard remap at every login, and loads it immediately so the
# remap is active in the current session too.

set -euo pipefail

readonly LABEL="@LABEL@"
readonly PLIST_SRC="@PLIST_SRC@"
readonly PLIST_DEST="$HOME/Library/LaunchAgents/${LABEL}.plist"

if [[ "$(uname)" != "Darwin" ]]; then
    echo "[ERROR] This script only runs on macOS" >&2
    exit 1
fi

mkdir -p "$HOME/Library/LaunchAgents"

echo "[INFO] Installing LaunchAgent to ${PLIST_DEST}"
cp "${PLIST_SRC}" "${PLIST_DEST}"

readonly GUI_DOMAIN="gui/$(id -u)"

# Unload any previously loaded copy first so the new mapping takes effect
# immediately, rather than only on next login.
launchctl bootout "${GUI_DOMAIN}/${LABEL}" 2>/dev/null || true

echo "[INFO] Bootstrapping LaunchAgent ${LABEL}"
launchctl bootstrap "${GUI_DOMAIN}" "${PLIST_DEST}"

echo "[INFO] Done. The remap is active now and will re-apply on every login."
