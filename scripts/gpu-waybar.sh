#!/bin/bash
# Waybar module: GPU load, VRAM and temperature for amdgpu (via sysfs).

dev=""
for d in /sys/class/drm/card*/device; do
    if [ -r "$d/gpu_busy_percent" ]; then
        dev="$d"
        break
    fi
done

if [ -z "$dev" ]; then
    echo '{"text": "", "class": "none"}'
    exit 0
fi

busy=$(<"$dev/gpu_busy_percent")
vram_used=$(<"$dev/mem_info_vram_used")
vram_total=$(<"$dev/mem_info_vram_total")
temp=""
for t in "$dev"/hwmon/hwmon*/temp1_input; do
    [ -r "$t" ] && temp=$(( $(<"$t") / 1000 )) && break
done

used_mb=$((vram_used / 1024 / 1024))
total_mb=$((vram_total / 1024 / 1024))

class=normal
[ "$busy" -ge 90 ] && class=critical
[ "$busy" -ge 70 ] && [ "$busy" -lt 90 ] && class=high

tooltip="GPU: ${busy}%\\nVRAM: ${used_mb} / ${total_mb} MiB"
[ -n "$temp" ] && tooltip="${tooltip}\\nTemp: ${temp}°C"

printf '{"text": "󰢮 %s%%", "class": "%s", "tooltip": "%s"}\n' "$busy" "$class" "$tooltip"
