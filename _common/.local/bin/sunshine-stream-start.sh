#!/bin/bash
# 1. Create the virtual display
hyprctl output create headless

MONITOR_NAME=$(hyprctl monitors -j | jq -r '.[] | select(.name | startswith("HEADLESS")) | .name')
# 1. Kill hypridle to prevent sleep/lock during stream
systemctl --user stop hypridle

# 2. Set resolution (adjust to your client's screen)
hyprctl keyword monitor "${MONITOR_NAME}, 3840x2160@60, 0x0, 1"

# sleep 1
# hyprctl dispatch moveworkspacetomonitor 8 ${MONITOR_NAME}
# hyprctl dispatch movetoworkspacesilent 8,title:^Lutris$
# hyprctl dispatch workspace 8
# hyprctl keyword cursor:no_hardware_cursors true

# 3. Disable your physical monitor (Change 'DP-1' to your real monitor name)
# hyprctl keyword monitor "DP-1, disable"
