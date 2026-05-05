#!/bin/bash

# Add Aerospace workspace change event
sketchybar --add event aerospace_workspace_change

# Get all available workspaces from Aerospace
WORKSPACES=($(aerospace list-workspaces --all))

# Create workspace items
for workspace in "${WORKSPACES[@]}"; do
  SPACE="space.$workspace"
  sketchybar --add item "$SPACE" left \
    --set "$SPACE" \
    icon="$workspace" \
    label.font="sketchybar-app-font:Regular:16.0" \
    label.padding_right=20 \
    label.y_offset=-1 \
    script="$PLUGIN_DIR/space.sh" \
    click_script="aerospace workspace $workspace" \
    --subscribe "$SPACE" aerospace_workspace_change front_app_switched window_focus
done

# Add workspace separator with app indicators
sketchybar --add item space_separator left \
  --set space_separator \
  icon="􀆊" \
  icon.color=$ACCENT_COLOR \
  icon.padding_left=4 \
  label.drawing=off \
  background.drawing=off \
  script="$PLUGIN_DIR/space_windows.sh" \
  update_freq=2 \
  --subscribe space_separator aerospace_workspace_change front_app_switched window_focus

