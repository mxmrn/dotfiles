#!/bin/bash
# Waybar module: aggregate Claude Code session states written by claude-status.sh.

dir="${XDG_RUNTIME_DIR:-/tmp}/claude-status"
shopt -s nullglob

# Sessions that never reported SessionEnd (crash, kill) expire after 12h
find "$dir" -type f -mmin +720 -delete 2>/dev/null

working=0
waiting=0
idle=0
for f in "$dir"/*; do
    case "$(<"$f")" in
        working) working=$((working + 1)) ;;
        waiting) waiting=$((waiting + 1)) ;;
        *) idle=$((idle + 1)) ;;
    esac
done
total=$((working + waiting + idle))

if [ "$total" -eq 0 ]; then
    echo '{"text": "", "class": "none"}'
    exit 0
fi

if [ "$waiting" -gt 0 ]; then
    class=waiting
elif [ "$working" -gt 0 ]; then
    class=working
else
    class=idle
fi

tooltip="working: $working\nwaiting: $waiting\nidle: $idle"
printf '{"text": "󰚩 %s", "class": "%s", "tooltip": "%s"}\n' "$total" "$class" "$tooltip"
