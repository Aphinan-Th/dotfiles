#!/bin/bash

source "$CONFIG_DIR/colors.sh"

# Separator between battery and calendar in the right island
sketchybar --add item right_separator right \
  --set right_separator \
  icon="│" \
  icon.font="SF Pro:Regular:16.0" \
  icon.color=$SEPARATOR_COLOR \
  icon.padding_left=4 \
  icon.padding_right=4 \
  label.drawing=off \
  background.drawing=off
