#!/bin/bash

# Update workspace app indicators for Aerospace
update_workspace() {
  local workspace=$1
  
  # Get all windows in the workspace with window IDs to ensure they're actual windows
  windows=$(aerospace list-windows --workspace "$workspace" --format "%{window-id}|%{app-name}" 2>/dev/null)
  
  # Extract unique app names from windows that actually exist
  apps=""
  if [ -n "$windows" ]; then
    apps=$(echo "$windows" | grep -v '^$' | cut -d'|' -f2 | grep -v '^$' | sort -u)
  fi
  
  icon_strip=""
  if [ -n "$apps" ] && [ "$apps" != "" ]; then
    while IFS= read -r app; do
      if [ -n "$app" ] && [ "$app" != "" ]; then
        icon_strip+=" $($CONFIG_DIR/plugins/icon_map_fn.sh "$app")"
      fi
    done <<< "$apps"
  fi
  
  # If no apps, set empty label, otherwise show the icons
  if [ -z "$icon_strip" ]; then
    sketchybar --set "space.$workspace" label=""
  else
    sketchybar --set "space.$workspace" label="$icon_strip"
  fi
}

# Always update all workspaces when this script is called
# This ensures icons are updated regardless of the trigger
WORKSPACES=($(aerospace list-workspaces --all))
for workspace in "${WORKSPACES[@]}"; do
  update_workspace "$workspace"
done

if [ "$SENDER" = "space_windows_change" ]; then
  # Legacy Yabai event handling (keeping for compatibility)
  space="$(echo "$INFO" | jq -r '.space')"
  apps="$(echo "$INFO" | jq -r '.apps | keys[]')"

  icon_strip=""
  if [ "${apps}" != "" ] && [ "${apps}" != "null" ]; then
    while read -r app; do
      if [ -n "$app" ]; then
        icon_strip+=" $($CONFIG_DIR/plugins/icon_map_fn.sh "$app")"
      fi
    done <<<"${apps}"
  fi

  # If no apps, set empty label, otherwise show the icons
  if [ -z "$icon_strip" ]; then
    sketchybar --set space.$space label=""
  else
    sketchybar --set space.$space label="$icon_strip"
  fi
fi
