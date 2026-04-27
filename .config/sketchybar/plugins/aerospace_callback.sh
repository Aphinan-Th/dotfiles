#!/bin/bash

# This script is called by Aerospace when workspace changes occur
# It triggers sketchybar to update the workspace indicators

# Trigger multiple events to ensure updates are caught
sketchybar --trigger aerospace_workspace_change
sketchybar --trigger front_app_switched
sketchybar --trigger window_focus

# Force update space_separator specifically
sketchybar --set space_separator script="$CONFIG_DIR/plugins/space_windows.sh" && sketchybar --update space_separator
