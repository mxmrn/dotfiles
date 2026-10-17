#!/bin/bash
# Pick the waybar layout by machine type and exec waybar.
# Started by waybar.service (see config/systemd/user/waybar.service.d).

CONFIG_DIR="$HOME/dotfiles/config/waybar"

layout=desktop
for supply in /sys/class/power_supply/BAT*; do
    if [ -e "$supply" ]; then
        layout=laptop
        break
    fi
done

exec waybar -c "$CONFIG_DIR/config-$layout.jsonc" -s "$CONFIG_DIR/style.css"
