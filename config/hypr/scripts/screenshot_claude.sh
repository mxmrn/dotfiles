#!/bin/bash
# Send active window screenshot directly to Claude Code TUI via kitty remote control
# Requires: grim, jq, kitty with allow_remote_control yes
# Launch claude with: kitty --class=claude-kitty --listen-on unix:/tmp/kitty-claude -e claude

SOCKET="unix:/tmp/kitty-claude"
FILE=$(mktemp /tmp/claude_shot_XXXXXX.png)

# Clean up screenshots older than 10 minutes — claude has long read them.
find /tmp -maxdepth 1 -name 'claude_shot_*.png' -mmin +10 -delete 2>/dev/null || true

if ! kitty @ --to "$SOCKET" ls > /dev/null 2>&1; then
    rm -f "$FILE"
    exit 1
fi

GEOM=$(hyprctl activewindow -j | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')
grim -g "$GEOM" "$FILE" || { rm -f "$FILE"; exit 1; }

kitty @ --to "$SOCKET" send-text --match "cmdline:claude" "@${FILE}"

CLAUDE_ADDR=$(hyprctl clients -j | jq -r '.[] | select(.class == "claude-kitty") | .address' | head -n1)
[ -n "$CLAUDE_ADDR" ] || exit 1

hyprctl dispatch "hl.dsp.send_shortcut({ mods = \"\", key = \"Return\", window = \"address:$CLAUDE_ADDR\" })"
sleep 0.1
hyprctl dispatch "hl.dsp.send_shortcut({ mods = \"\", key = \"Return\", window = \"address:$CLAUDE_ADDR\" })"
