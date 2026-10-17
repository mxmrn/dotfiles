#!/usr/bin/env bash
# Build a Bibata wrapper theme where move/resize cursors are a plain arrow,
# so Hyprland's movewindow/resizewindow don't change the pointer shape.

set -euo pipefail

BASE="Bibata-Modern-Ice"
NAME="${BASE}-Static"
SRC="/usr/share/icons/${BASE}/cursors"
DEST="${HOME}/.local/share/icons/${NAME}"

[[ -d "${SRC}" ]] || { echo "${SRC} not found" >&2; exit 1; }

rm -rf "${DEST}"
mkdir -p "${DEST}/cursors"

cat >"${DEST}/index.theme" <<EOF
[Icon Theme]
Name=${NAME}
Inherits=${BASE}
EOF

# Cursor names Hyprland requests while dragging or resizing windows
names=(
    grab grabbing closedhand openhand move fleur all-scroll size_all
    pointer-move dnd-move
    n-resize s-resize e-resize w-resize
    ne-resize nw-resize se-resize sw-resize
    ns-resize ew-resize nesw-resize nwse-resize
    col-resize row-resize
    top_side bottom_side left_side right_side
    top_left_corner top_right_corner bottom_left_corner bottom_right_corner
    size_hor size_ver size-hor size-ver size_bdiag size_fdiag
    sb_h_double_arrow sb_v_double_arrow h_double_arrow v_double_arrow
    double_arrow bd_double_arrow fd_double_arrow
)

for n in "${names[@]}"; do
    ln -sf "${SRC}/left_ptr" "${DEST}/cursors/${n}"
done

echo "Created ${DEST}"
