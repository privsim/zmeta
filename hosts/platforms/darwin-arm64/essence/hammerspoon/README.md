# Hammerspoon Configuration

The hyper keys are defined as `⌘ + ⌥ + ⌃` (control + option + command) and `⌘ + ⌥` (command + option). Press these plus the defined key:

## General Actions

| Key | Action        |
| --- | ------------- |
| A   | Lock Screen   |
| R   | Reload config |

## Launch Apps

| Key | App                |
| --- | ------------------ |
| C   | Chromium           |
| E   | Editor (VS Code)   |
| F   | Finder             |
| G   | SourceTree (Git)   |
| K   | Cursor             |
| P   | System Preferences |
| S   | Spotify            |
| T   | Terminal           |

## Window Management

### Window Movement Between Screens
| Key | Action                    |
| --- | ------------------------- |
| H   | Move window to left screen |
| L   | Move window to right screen|
| K   | Move window to upper screen|
| J   | Move window to lower screen|

### Window Resizing and Grid
| Key | Action                    |
| --- | ------------------------- |
| 1   | Cycle size left          |
| 2   | Cycle size right         |
| 3   | Cycle size up            |
| 4   | Cycle size down          |
| I   | Decrease height          |
| K   | Increase height          |
| J   | Decrease width           |
| L   | Increase width           |
| 5   | Set 2x2 grid            |
| 6   | Set 3x3 grid            |
| 7   | Set 4x4 grid            |
| /   | Move window to next screen|
| ,   | Snap window to grid      |
| (space) | Maximize window    |
| .   | Minimize window          |
| ⌘ + Enter | Toggle maximize window |

### Window Cycling and Workspace
| Key | Action                              |
| --- | ----------------------------------- |
| ⌘ + ⌥ + Tab | Cycle through windows of same app |
| ⌘ + ⌥ + /   | Move window to next workspace     |
| ⌘ + ⌥ + ⇧ + / | Move window to previous workspace |

## Desktop Canvas
| Key | Action                    |
| --- | ------------------------- |
| D   | Toggle drawing mode       |
| T   | Add text note            |
| C   | Clear canvas             |
| S   | Save canvas              |
| 1   | Set color to black       |
| 2   | Set color to red         |
| 3   | Set color to blue        |
| 4   | Set color to green       |

## Media Controls

| Key | Action                   |
| --- | ------------------------ |
| V   | Unmute volume            |
| M   | Mute volume              |
| [   | Previous track (Control) |
| ]   | Next track (Control)     |

## Clipboard Management

| Key | Action                              |
| --- | ----------------------------------- |
| V   | Show clipboard history and paste    |

## Shortcuts Display

There are two ways to view all available shortcuts:

1. **KSheet Display** (`⌃ + ⌥ + ⌘ + /`)
   - Shows all system-wide shortcuts
   - Includes Hammerspoon shortcuts in a separate panel

2. **Hammerspoon Shortcuts** (`⌃ + ⌥ + ⌘ + H`)
   - Dedicated display for Hammerspoon shortcuts
   - Organized by category
   - Shows all custom hotkeys and their descriptions
