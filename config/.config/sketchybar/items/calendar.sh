#!/bin/bash

sketchybar --add item calendar right \
  --set calendar \
  icon.drawing=off \
  label.color=$ACCENT_COLOR \
  label.font="SF Pro:Semibold:12.0" \
  background.drawing=off \
  update_freq=30 \
  script="$PLUGIN_DIR/calendar.sh"
