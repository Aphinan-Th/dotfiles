#!/bin/bash

source "$CONFIG_DIR/colors.sh" # Loads all defined colors

# Get the current focused workspace from Aerospace
FOCUSED_WORKSPACE=$(aerospace list-workspaces --focused)

# Extract workspace ID from the item name (space.X -> X)
WORKSPACE_ID=${NAME#space.}

if [ "$WORKSPACE_ID" = "$FOCUSED_WORKSPACE" ]; then
  sketchybar --set $NAME background.drawing=on
else
  sketchybar --set $NAME background.drawing=off
fi

# if [ "$WORKSPACE_ID" = "$FOCUSED_WORKSPACE" ]; then
#   sketchybar --set $NAME background.drawing=on \
#     background.color=$ACCENT_COLOR \
#     label.color=$BAR_COLOR \
#     icon.color=$BAR_COLOR
# else
#   sketchybar --set $NAME background.drawing=off \
#     label.color=$ACCENT_COLOR \
#     icon.color=$ACCENT_COLOR
# fi
