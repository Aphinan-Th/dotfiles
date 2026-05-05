#!/bin/bash

source "$CONFIG_DIR/colors.sh"

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
    icon.font="SF Pro:Bold:12.0" \
    icon.color=$DIM_WHITE \
    icon.padding_left=8 \
    icon.padding_right=4 \
    icon.align=center \
    label.font="sketchybar-app-font:Regular:14.0" \
    label.padding_right=6 \
    label.color=$DIM_WHITE \
    background.drawing=off \
    padding_left=4 \
    padding_right=4 \
    script="$PLUGIN_DIR/space.sh" \
    click_script="aerospace workspace $workspace" \
    --subscribe "$SPACE" aerospace_workspace_change front_app_switched window_focus
done

# Separator between workspaces and front app
sketchybar --add item space_separator left \
  --set space_separator \
  icon="│" \
  icon.font="SF Pro:Regular:16.0" \
  icon.color=$SEPARATOR_COLOR \
  icon.padding_left=6 \
  icon.padding_right=6 \
  label.drawing=off \
  background.drawing=off \
  script="$PLUGIN_DIR/space_windows.sh" \
  update_freq=2 \
  --subscribe space_separator aerospace_workspace_change front_app_switched window_focus
