#!/bin/bash

sketchybar --add item battery right \
  --set battery \
  icon.font="SF Pro:Semibold:14.0" \
  label.font="SF Pro:Semibold:12.0" \
  background.drawing=off \
  update_freq=120 \
  script="$PLUGIN_DIR/battery.sh" \
  --subscribe battery system_woke power_source_change
