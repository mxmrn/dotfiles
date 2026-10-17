#!/bin/bash
# Screenshot script for Hyprland
# Usage:
#   screenshot.sh        - fullscreen to clipboard
#   screenshot.sh area   - area selection to clipboard + editor

DIR="$HOME/Pictures/screenshots"
FILE="$DIR/screenshot_$(date +%Y%m%d_%H%M%S).png"

mkdir -p "$DIR"

# Get screenshot editor from env (satty/swappy), fall back to what is installed
EDITOR_CMD="${SCREENSHOT_EDITOR:-satty}"
command -v "$EDITOR_CMD" >/dev/null 2>&1 || EDITOR_CMD=swappy

edit() {
    case "$EDITOR_CMD" in
        satty) satty --filename "$1" --output-filename "$1" --copy-command wl-copy --early-exit ;;
        *) "$EDITOR_CMD" -f "$1" ;;
    esac
}

case "$1" in
    "area")
        # Selection cancelled -> nothing to capture
        geometry=$(slurp) || exit 0
        if grim -g "$geometry" "$FILE"; then
            wl-copy < "$FILE"
            notify-send "Screenshot captured" "Area selection saved and copied to clipboard"
            edit "$FILE"
        fi
        ;;
    *)
        # Fullscreen active monitor
        active_monitor=$(hyprctl -j activeworkspace | jq -r '.monitor')
        if grim -o "$active_monitor" "$FILE"; then
            wl-copy < "$FILE"
            notify-send "Screenshot captured" "Active monitor saved and copied to clipboard"
        fi
        ;;
esac
