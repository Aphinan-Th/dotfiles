#!/bin/bash

source "$CONFIG_DIR/colors.sh"

# Get the current focused workspace from Aerospace
FOCUSED_WORKSPACE=$(aerospace list-workspaces --focused)

# Extract workspace ID from the item name (space.X -> X)
WORKSPACE_ID=${NAME#space.}

if [ "$WORKSPACE_ID" = "$FOCUSED_WORKSPACE" ]; then
  sketchybar --set $NAME \
    icon.color=$ACCENT_COLOR \
    icon.shadow.drawing=on \
    icon.shadow.color=$ACCENT_COLOR \
    icon.shadow.distance=0 \
    label.color=$ACCENT_COLOR \
    icon.font="SF Pro:Bold:13.0"
else
  sketchybar --set $NAME \
    icon.color=$DIM_WHITE \
    icon.shadow.drawing=off \
    label.color=$DIM_WHITE \
    icon.font="SF Pro:Bold:12.0"
fi
