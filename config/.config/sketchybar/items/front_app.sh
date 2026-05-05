#!/bin/bash

sketchybar --add item front_app left \
  --set front_app \
  icon.font="sketchybar-app-font:Regular:16.0" \
  label.font="SF Pro:Semibold:12.0" \
  label.color=$WHITE \
  label.padding_right=8 \
  background.drawing=off \
  script="$PLUGIN_DIR/front_app.sh" \
  --subscribe front_app front_app_switched
