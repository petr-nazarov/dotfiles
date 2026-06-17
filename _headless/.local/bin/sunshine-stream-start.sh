#!/bin/bash
# 1. Create the virtual display
hyprctl output create headless

MONITOR_NAME=$(hyprctl monitors -j | jq -r '.[] | select(.name | startswith("HEADLESS")) | .name')
# 1. Kill hypridle to prevent sleep/lock during stream
systemctl --user stop hypridle

# 2. Set resolution (adjust to your client's screen)
hyprctl keyword monitor "${MONITOR_NAME}, 3840x2160@60, 3440x0, 1"

# 3. Move all windows to workspace 1 on the virtual monitor
hyprctl clients -j | jq -r '.[].address' | while read -r addr; do
  hyprctl dispatch movetoworkspacesilent "1,address:${addr}"
done

# 4. Focus workspace 1 on the virtual monitor
hyprctl dispatch focusmonitor "${MONITOR_NAME}"
hyprctl dispatch workspace 1

# 5. Disable your physical monitor
hyprctl keyword monitor "DP-1, disable"

notify-attention "Sunshine Stream" "Stream started on virtual display ${MONITOR_NAME} at 3840x2160@60Hz"
