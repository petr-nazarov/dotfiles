#!/bin/bash
# 1. Re-enable physical monitor
hyprctl keyword monitor "DP-2, 3440x1440@144, 0x0, 1"

# 2. Delete the virtual display to save resources
hyprctl monitors -j | jq -r '.[] | select(.name | startswith("HEADLESS")) | .name' | xargs -I {} hyprctl output remove {}

systemctl --user start hypridle
