#!/bin/bash
# Claude Code hook: record the session state for the waybar module.
# Usage (from hooks): claude-status.sh working|waiting|idle|end
# Reads the hook JSON from stdin.

state="$1"
dir="${XDG_RUNTIME_DIR:-/tmp}/claude-status"
mkdir -p "$dir"

input=$(cat)
sid=$(jq -r '.session_id // empty' <<<"$input")
[ -n "$sid" ] || exit 0

# An idle-prompt notification is not a request for attention
if [ "$state" = waiting ] && [ "$(jq -r '.notification_type // empty' <<<"$input")" = idle_prompt ]; then
    state=idle
fi

if [ "$state" = end ]; then
    rm -f "$dir/$sid"
else
    printf '%s' "$state" > "$dir/$sid"
fi
