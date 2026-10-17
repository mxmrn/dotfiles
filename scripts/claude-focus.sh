#!/bin/bash
# Focus the Claude Code window, or start it when it is not running.

if hyprctl clients -j | jq -e '.[] | select(.class == "claude-kitty")' >/dev/null; then
    hyprctl dispatch "hl.dsp.focus({ window = 'class:claude-kitty' })"
else
    kitty --class=claude-kitty --listen-on unix:/tmp/kitty-claude -e claude &
fi
