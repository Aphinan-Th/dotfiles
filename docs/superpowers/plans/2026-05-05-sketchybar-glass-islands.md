# SketchyBar Glass Islands Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Redesign SketchyBar into a two-island frosted glass layout with cyan/teal accent, replacing the current full-width bar.

**Architecture:** Two bracket-grouped "islands" (left for workspaces+app, right for battery+clock) on a fully transparent bar. Individual items have no background — brackets provide the frosted glass pill appearance. Color scheme centralized in `colors.sh`.

**Tech Stack:** SketchyBar (shell-based config), AeroSpace (workspace events), Bash scripts

**Spec:** `docs/superpowers/specs/2026-05-05-sketchybar-glass-islands-design.md`

---

### Task 1: Update Color Scheme

**Files:**
- Modify: `config/.config/sketchybar/colors.sh`

- [ ] **Step 1: Replace colors.sh with the new cyan/teal glass palette**

Replace the entire contents of `config/.config/sketchybar/colors.sh` with:

```bash
#!/bin/bash

export WHITE=0xffffffff
export BAR_COLOR=0x00000000          # Fully transparent bar
export ITEM_BG_COLOR=0x12ffffff      # ~7% white for glass effect
export ACCENT_COLOR=0xff00d2ff       # Cyan accent
export ACCENT_SECONDARY=0xff3a7bd5   # Deeper blue for gradients
export DIM_WHITE=0x66ffffff          # 40% white for inactive elements
export SEPARATOR_COLOR=0x1affffff    # 10% white for divider lines
export BORDER_COLOR=0x0fffffff       # 6% white for island borders
```

- [ ] **Step 2: Verify the file**

Run: `cat config/.config/sketchybar/colors.sh`
Expected: All 8 exports, no commented-out color schemes.

- [ ] **Step 3: Commit**

```bash
git add config/.config/sketchybar/colors.sh
git commit -m "Update SketchyBar color scheme to cyan/teal glass palette"
```

---

### Task 2: Update Bar Defaults and Item Sources in sketchybarrc

**Files:**
- Modify: `config/.config/sketchybar/sketchybarrc`

- [ ] **Step 1: Update bar appearance and defaults**

Replace the full contents of `config/.config/sketchybar/sketchybarrc` with:

```bash
#!/bin/bash

source "$CONFIG_DIR/colors.sh"

PLUGIN_DIR="$CONFIG_DIR/plugins"
ITEM_DIR="$CONFIG_DIR/items"

##### Bar Appearance #####
sketchybar --bar height=37 \
  blur_radius=30 \
  position=top \
  sticky=off \
  padding_left=10 \
  padding_right=10 \
  color=$BAR_COLOR

##### Changing Defaults #####
sketchybar --default icon.font="SF Pro:Semibold:13.0" \
  icon.color=$WHITE \
  label.font="SF Pro:Semibold:13.0" \
  label.color=$WHITE \
  background.drawing=off \
  padding_left=4 \
  padding_right=4 \
  label.padding_left=4 \
  label.padding_right=4 \
  icon.padding_left=4 \
  icon.padding_right=4

# -- Left Island Items --
source $ITEM_DIR/spaces.sh
source $ITEM_DIR/front_app.sh

# -- Right Island Items --
source $ITEM_DIR/calendar.sh
source $ITEM_DIR/battery.sh

# -- Island Brackets --
source $ITEM_DIR/brackets.sh

##### Finalizing Setup #####
sketchybar --update
```

Key changes from current file:
- Removed `background.color`, `background.corner_radius`, `background.height` from defaults (brackets handle this)
- Added `background.drawing=off` to defaults
- Reduced font size from 15.0 to 13.0
- Reduced padding values for compact islands
- Removed source lines for `apple.sh`, `media.sh`, `volume.sh`, `cpu.sh`
- Added `source $ITEM_DIR/brackets.sh` for island grouping

- [ ] **Step 2: Commit**

```bash
git add config/.config/sketchybar/sketchybarrc
git commit -m "Update sketchybarrc for glass islands layout"
```

---

### Task 3: Update Workspace Items (spaces.sh)

**Files:**
- Modify: `config/.config/sketchybar/items/spaces.sh`

- [ ] **Step 1: Rewrite spaces.sh for glass island styling**

Replace the full contents of `config/.config/sketchybar/items/spaces.sh` with:

```bash
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
    label.font="sketchybar-app-font:Regular:14.0" \
    label.padding_right=6 \
    label.color=$DIM_WHITE \
    background.drawing=off \
    padding_left=2 \
    padding_right=2 \
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
```

Key changes:
- Workspace numbers use `SF Pro:Bold:12.0` with `$DIM_WHITE` color (active state handled by `space.sh` plugin)
- App icon labels use `sketchybar-app-font:Regular:14.0` (slightly smaller)
- Separator changed from `􀆊` SF Symbol to `│` pipe character with `$SEPARATOR_COLOR`
- All items have `background.drawing=off`
- Tighter padding for compact island feel

- [ ] **Step 2: Commit**

```bash
git add config/.config/sketchybar/items/spaces.sh
git commit -m "Update workspace items for glass island styling"
```

---

### Task 4: Update Space Plugin (active/inactive styling)

**Files:**
- Modify: `config/.config/sketchybar/plugins/space.sh`

- [ ] **Step 1: Rewrite space.sh for cyan accent active state**

Replace the full contents of `config/.config/sketchybar/plugins/space.sh` with:

```bash
#!/bin/bash

source "$CONFIG_DIR/colors.sh"

# Get the current focused workspace from Aerospace
FOCUSED_WORKSPACE=$(aerospace list-workspaces --focused)

# Extract workspace ID from the item name (space.X -> X)
WORKSPACE_ID=${NAME#space.}

if [ "$WORKSPACE_ID" = "$FOCUSED_WORKSPACE" ]; then
  sketchybar --set $NAME \
    icon.color=$ACCENT_COLOR \
    label.color=$ACCENT_COLOR \
    icon.font="SF Pro:Bold:13.0"
else
  sketchybar --set $NAME \
    icon.color=$DIM_WHITE \
    label.color=$DIM_WHITE \
    icon.font="SF Pro:Bold:12.0"
fi
```

Key changes:
- Active workspace: cyan accent color on both icon (number) and label (app icons), slightly larger font
- Inactive workspace: dim white on both, smaller font
- Removed background.drawing toggle — brackets handle backgrounds now

- [ ] **Step 2: Commit**

```bash
git add config/.config/sketchybar/plugins/space.sh
git commit -m "Update space plugin with cyan accent active/inactive states"
```

---

### Task 5: Update Front App Item

**Files:**
- Modify: `config/.config/sketchybar/items/front_app.sh`

- [ ] **Step 1: Simplify front_app.sh**

Replace the full contents of `config/.config/sketchybar/items/front_app.sh` with:

```bash
#!/bin/bash

sketchybar --add item front_app left \
  --set front_app \
  icon.font="sketchybar-app-font:Regular:16.0" \
  label.font="SF Pro:Semibold:12.0" \
  label.color=$WHITE \
  background.drawing=off \
  script="$PLUGIN_DIR/front_app.sh" \
  --subscribe front_app front_app_switched
```

Key changes:
- Explicit `label.font` at 12.0 for compact size
- `background.drawing=off` (bracket handles background)
- Removed commented-out accent background variant

- [ ] **Step 2: Commit**

```bash
git add config/.config/sketchybar/items/front_app.sh
git commit -m "Simplify front app item for glass island layout"
```

---

### Task 6: Update Calendar Item with Cyan Accent

**Files:**
- Modify: `config/.config/sketchybar/items/calendar.sh`
- Modify: `config/.config/sketchybar/plugins/calendar.sh`

- [ ] **Step 1: Update calendar item definition**

Replace the full contents of `config/.config/sketchybar/items/calendar.sh` with:

```bash
#!/bin/bash

sketchybar --add item calendar right \
  --set calendar \
  icon.drawing=off \
  label.color=$ACCENT_COLOR \
  label.font="SF Pro:Semibold:12.0" \
  background.drawing=off \
  update_freq=30 \
  script="$PLUGIN_DIR/calendar.sh"
```

Key changes:
- Removed the `icon=􀧞` — cleaner without icon, just the date/time text
- Label color set to `$ACCENT_COLOR` (cyan)
- Explicit font size 12.0

- [ ] **Step 2: Update calendar plugin for shorter format**

Replace the full contents of `config/.config/sketchybar/plugins/calendar.sh` with:

```bash
#!/bin/bash

sketchybar --set $NAME label="$(date +'%a %H:%M')"
```

Key change: Shorter format — "Mon 14:34" instead of "Mon 05 May 02:34 PM". Uses 24h clock for compactness.

- [ ] **Step 3: Commit**

```bash
git add config/.config/sketchybar/items/calendar.sh config/.config/sketchybar/plugins/calendar.sh
git commit -m "Update calendar item with cyan accent and compact format"
```

---

### Task 7: Update Battery Item

**Files:**
- Modify: `config/.config/sketchybar/items/battery.sh`

- [ ] **Step 1: Update battery item definition**

Replace the full contents of `config/.config/sketchybar/items/battery.sh` with:

```bash
#!/bin/bash

sketchybar --add item battery right \
  --set battery \
  icon.font="SF Pro:Semibold:14.0" \
  label.font="SF Pro:Semibold:12.0" \
  background.drawing=off \
  update_freq=120 \
  script="$PLUGIN_DIR/battery.sh" \
  --subscribe battery system_woke power_source_change
```

Key changes:
- `background.drawing=off` (bracket handles background)
- Explicit font sizes

- [ ] **Step 2: Commit**

```bash
git add config/.config/sketchybar/items/battery.sh
git commit -m "Update battery item for glass island layout"
```

---

### Task 8: Create Island Brackets

**Files:**
- Create: `config/.config/sketchybar/items/brackets.sh`

- [ ] **Step 1: Create brackets.sh for island grouping**

Create `config/.config/sketchybar/items/brackets.sh` with:

```bash
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

# Right island: battery + calendar
sketchybar --add bracket right_island battery calendar \
  --set right_island \
  background.color=$ITEM_BG_COLOR \
  background.corner_radius=13 \
  background.height=28 \
  background.border_color=$BORDER_COLOR \
  background.border_width=1 \
  background.drawing=on
```

This creates the two frosted glass pills. The bracket dynamically includes whatever workspaces AeroSpace reports, so it works if workspaces are added/removed.

- [ ] **Step 2: Make it executable**

Run: `chmod +x config/.config/sketchybar/items/brackets.sh`

- [ ] **Step 3: Commit**

```bash
git add config/.config/sketchybar/items/brackets.sh
git commit -m "Add island bracket groups for glass pill effect"
```

---

### Task 9: Add Right Island Separator

**Files:**
- Create: `config/.config/sketchybar/items/right_separator.sh`
- Modify: `config/.config/sketchybar/sketchybarrc`

- [ ] **Step 1: Create right_separator.sh**

Create `config/.config/sketchybar/items/right_separator.sh` with:

```bash
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
```

- [ ] **Step 2: Add source line to sketchybarrc**

In `config/.config/sketchybar/sketchybarrc`, update the right island items section to:

```bash
# -- Right Island Items --
source $ITEM_DIR/calendar.sh
source $ITEM_DIR/right_separator.sh
source $ITEM_DIR/battery.sh
```

Note: Items are added right-to-left in SketchyBar when using `right` position, so `calendar` (rightmost visually) is sourced first, then separator, then battery.

- [ ] **Step 3: Update brackets.sh to include right_separator**

In `config/.config/sketchybar/items/brackets.sh`, update the right island bracket:

```bash
# Right island: battery + separator + calendar
sketchybar --add bracket right_island battery right_separator calendar \
  --set right_island \
  background.color=$ITEM_BG_COLOR \
  background.corner_radius=13 \
  background.height=28 \
  background.border_color=$BORDER_COLOR \
  background.border_width=1 \
  background.drawing=on
```

- [ ] **Step 4: Make right_separator.sh executable**

Run: `chmod +x config/.config/sketchybar/items/right_separator.sh`

- [ ] **Step 5: Commit**

```bash
git add config/.config/sketchybar/items/right_separator.sh config/.config/sketchybar/sketchybarrc config/.config/sketchybar/items/brackets.sh
git commit -m "Add separator between battery and calendar in right island"
```

---

### Task 10: Test and Reload

- [ ] **Step 1: Verify all scripts are executable**

Run: `ls -la config/.config/sketchybar/items/ config/.config/sketchybar/plugins/`
Expected: All `.sh` files should have execute permissions.

- [ ] **Step 2: Fix any non-executable scripts**

Run: `chmod +x config/.config/sketchybar/items/*.sh config/.config/sketchybar/plugins/*.sh`

- [ ] **Step 3: Check for syntax errors in all modified files**

Run: `bash -n config/.config/sketchybar/sketchybarrc && bash -n config/.config/sketchybar/colors.sh && bash -n config/.config/sketchybar/items/spaces.sh && bash -n config/.config/sketchybar/items/front_app.sh && bash -n config/.config/sketchybar/items/calendar.sh && bash -n config/.config/sketchybar/items/battery.sh && bash -n config/.config/sketchybar/items/brackets.sh && bash -n config/.config/sketchybar/items/right_separator.sh && bash -n config/.config/sketchybar/plugins/space.sh && bash -n config/.config/sketchybar/plugins/calendar.sh && echo "All files OK"`

Expected: "All files OK"

- [ ] **Step 4: Reload SketchyBar**

Run: `sketchybar --reload`

This reloads the config. Visually verify the two floating glass islands appear correctly.

- [ ] **Step 5: Final commit if any fixups were needed**

```bash
git add -A config/.config/sketchybar/
git commit -m "Fix any remaining issues from SketchyBar glass islands reload"
```

Only commit if there were fixups. If everything worked on first try, skip this step.
