# SketchyBar Glass Islands Redesign

## Overview

Redesign SketchyBar from the current full-width bar with individual item backgrounds to a "Glass Islands" layout — two floating frosted-glass pills (left and right) on a fully transparent bar, with a cyan/teal accent color.

## Design Decisions

- **Style:** Glass Islands — separated floating pills instead of a continuous bar
- **Color palette:** Cyan/Teal accent (#00d2ff → #3a7bd5 gradient) on dark transparent background
- **Layout:** Two islands only (left + right), no center island
- **Removed items:** Apple logo, media/now-playing, volume, CPU

## Bar Configuration

- **Position:** Top
- **Height:** 37px (unchanged)
- **Background:** Fully transparent (`0x00000000`)
- **Blur radius:** 30 (unchanged, provides frosted effect behind islands)
- **Padding:** 10px left/right

## Left Island — Workspaces & Front App

Contains all workspace and app-focus information in a single frosted pill.

### Structure

```
[ (dot) 1  (dot) 2  (dot) 3  (dot) S  |  icon AppName ]
   ^app     ^app            
  icons    icons
```

### Items

1. **Workspace indicators** (`space.1`, `space.2`, `space.3`, `space.S`)
   - Each workspace shows a dot + number
   - Active workspace: dot uses cyan gradient fill (`#00d2ff` → `#3a7bd5`) with glow shadow, number in cyan
   - Inactive workspace: dot is dim white (~20% opacity), number in dim white (~40% opacity)
   - App icons displayed below/beside each workspace dot (using `sketchybar-app-font`)
   - Click action: `aerospace workspace <id>` (unchanged)
   - Subscribed events: `aerospace_workspace_change`, `front_app_switched`, `window_focus`

2. **Separator** — thin vertical line (1px, white at 10% opacity) between workspaces and front app

3. **Front app** (`front_app`)
   - Shows app icon (via `sketchybar-app-font` and `icon_map_fn.sh`) + app name label
   - Subscribed events: `front_app_switched`

### Island Styling (applied via bracket/group)

- Background: `rgba(255,255,255,0.07)` → SketchyBar hex: `0x12ffffff`
- Corner radius: 13px
- Border: 1px, `rgba(255,255,255,0.06)` → `0x0fffffff`
- Height: 28px
- Padding: 7px vertical, 16px horizontal

## Right Island — Battery & Clock

Minimal status pill with only essential information.

### Structure

```
[ 🔋 87%  |  Mon 12:34 ]
```

### Items

1. **Battery** (`battery`)
   - Icon + percentage label
   - Update frequency: 120s (unchanged)
   - Subscribed events: `system_woke`, `power_source_change`

2. **Separator** — same thin vertical line style as left island

3. **Calendar/Clock** (`calendar`)
   - Format: abbreviated day + time (e.g., "Mon 12:34")
   - Clock label in cyan accent color (`#00d2ff` → `0xff00d2ff`)
   - Update frequency: 30s (unchanged)

### Island Styling

Same glass styling as left island.

## Color Scheme (colors.sh)

```bash
export WHITE=0xffffffff
export BAR_COLOR=0x00000000          # Fully transparent bar
export ITEM_BG_COLOR=0x12ffffff      # ~7% white for glass effect
export ACCENT_COLOR=0xff00d2ff       # Cyan accent
export ACCENT_SECONDARY=0xff3a7bd5   # Deeper blue for gradients
export DIM_WHITE=0x66ffffff          # 40% white for inactive elements
export SEPARATOR_COLOR=0x1affffff    # 10% white for divider lines
export BORDER_COLOR=0x0fffffff       # 6% white for island borders
```

## Files to Modify

1. **`colors.sh`** — Replace color scheme with cyan/teal glass palette
2. **`sketchybarrc`** — Update bar defaults, remove apple/media/volume/cpu item sources, add bracket grouping for islands
3. **`items/spaces.sh`** — Update workspace styling (dot indicators, active glow via background color)
4. **`items/front_app.sh`** — Simplify to icon + label, no accent background
5. **`items/calendar.sh`** — Add cyan accent to clock label
6. **`items/battery.sh`** — No major changes, inherits island styling
7. **`plugins/space.sh`** — Update active/inactive styling to use cyan accent and dim states

## Files to Remove (item sources only, keep plugin scripts)

- `items/apple.sh` — Remove from `sketchybarrc` source list
- `items/media.sh` — Remove from `sketchybarrc` source list
- `items/volume.sh` — Remove from `sketchybarrc` source list
- `items/cpu.sh` — Remove from `sketchybarrc` source list

Note: Keep the item and plugin files on disk (not deleted) in case you want to re-enable them later. Only remove the `source` lines from `sketchybarrc`.

## SketchyBar Bracket Groups

Use SketchyBar's bracket feature to visually group items into islands:

```bash
# Left island bracket
sketchybar --add bracket left_island space.1 space.2 space.3 space.S space_separator front_app \
  --set left_island \
    background.color=$ITEM_BG_COLOR \
    background.corner_radius=13 \
    background.height=28 \
    background.border_color=$BORDER_COLOR \
    background.border_width=1

# Right island bracket
sketchybar --add bracket right_island battery calendar \
  --set right_island \
    background.color=$ITEM_BG_COLOR \
    background.corner_radius=13 \
    background.height=28 \
    background.border_color=$BORDER_COLOR \
    background.border_width=1
```

## Default Item Styling Changes

Individual items should have `background.drawing=off` since the bracket provides the shared background. Key defaults:

- `icon.font`: SF Pro Semibold 13.0
- `label.font`: SF Pro Semibold 13.0
- `icon.color`: `$WHITE`
- `label.color`: `$WHITE`
- `background.drawing`: off (bracket handles backgrounds)
- Padding between items reduced to keep islands compact
