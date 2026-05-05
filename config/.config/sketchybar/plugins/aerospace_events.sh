#!/bin/bash

# This script should be called by Aerospace when workspace changes occur
# Add this to your Aerospace configuration:
# 
# [mode.main.binding]
# cmd-1 = ['workspace 1', 'exec-and-forget sketchybar --trigger aerospace_workspace_change']
# cmd-2 = ['workspace 2', 'exec-and-forget sketchybar --trigger aerospace_workspace_change']
# ... etc for all your workspaces

# Trigger the workspace change event
sketchybar --trigger aerospace_workspace_change

# Also update the space indicators for all workspaces
WORKSPACES=($(aerospace list-workspaces --all))
for workspace in "${WORKSPACES[@]}"; do
  # Get apps in this workspace
  apps=$(aerospace list-windows --workspace "$workspace" --format "%{app-name}" | sort -u)
  
  icon_strip=""
  if [ -n "$apps" ]; then
    while IFS= read -r app; do
      if [ -n "$app" ]; then
        icon_strip+=" $($CONFIG_DIR/plugins/icon_map_fn.sh "$app")"
      fi
    done <<< "$apps"
  else
    icon_strip=" —"
  fi
  
  sketchybar --set "space.$workspace" label="$icon_strip"
done
