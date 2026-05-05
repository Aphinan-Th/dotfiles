#!/bin/bash

source "$CONFIG_DIR/colors.sh"

# Get all workspace item names for the left island bracket
WORKSPACE_ITEMS=()
WORKSPACES=($(aerospace list-workspaces --all))
for workspace in "${WORKSPACES[@]}"; do
  WORKSPACE_ITEMS+=("space.$workspace")
done

# Left island: all workspace items + separator + front app
sketchybar --add bracket left_island "${WORKSPACE_ITEMS[@]}" space_separator front_app \
  --set left_island \
  background.color=$ITEM_BG_COLOR \
  background.corner_radius=13 \
  background.height=28 \
  background.border_color=$BORDER_COLOR \
  background.border_width=1 \
  background.drawing=on

# Right island: battery + separator + calendar
sketchybar --add bracket right_island battery right_separator calendar \
  --set right_island \
  background.color=$ITEM_BG_COLOR \
  background.corner_radius=13 \
  background.height=28 \
  background.border_color=$BORDER_COLOR \
  background.border_width=1 \
  background.drawing=on
