# Hammerspoon Configuration Overview

## Current State Analysis

### init.lua
Main configuration file issues:
- Duplicate window management code (toggleMaximize appears in both init.lua and grid.lua)
- Multiple modifier key definitions that may conflict
- Inconsistent use of Unicode vs. text for modifier keys
- Screen movement functions could be consolidated with other window management

### grid.lua
Window management issues:
- Simplified but still references grid functionality in some places
- Potential conflicts with init.lua window management
- Inconsistent window behavior between maximize and half-screen functions
- Missing window snapping functionality

### shortcuts.lua
Major issues:
- Complex categorization logic that may misclassify shortcuts
- Duplicate shortcut displays (KSheet and custom implementation)
- Overlapping categories causing confusion
- No clear separation between system and custom shortcuts

### hotkeys.lua
Problems identified:
- Potential conflicts with shortcuts.lua
- Unclear integration with KSheet
- Missing documentation for custom bindings
- Inconsistent modifier key usage

### Other Files
- wallpaper.lua: Possibly unnecessary complexity
- clipboard.lua: Redundant with ClipboardTool Spoon
- move_workspace.lua: Potential conflicts with screen movement in init.lua
- apps.lua: Could be simplified
- cycle_windows.lua: May conflict with other window management

## Action Plan

### 1. Consolidate Window Management (Priority: High)
1. Create new `windows.lua`:
   - Merge functionality from grid.lua and init.lua
   - Implement consistent window operations
   - Use single set of modifier keys
   - Add proper window snapping
   - Remove grid dependency

2. Standardize window commands:
   ```lua
   -- Proposed structure
   local windows = {
     modifiers = {"cmd", "alt"},
     shortcuts = {
       movement = {
         left = "left",
         right = "right",
         up = "up",
         down = "down"
       },
       screens = {
         next = "/",
         previous = "\\"
       },
       actions = {
         maximize = "space",
         minimize = ".",
         restore = "return"
       }
     }
   }
   ```

### 2. Simplify Shortcut Management (Priority: High)
1. Remove custom shortcuts display
2. Enhance KSheet integration:
   - Add proper categorization
   - Improve visibility
   - Fix black page issue
   - Remove "by dharma poudel" text

3. Standardize modifier keys:
   ```lua
   -- Proposed structure
   local modifiers = {
     window = {"cmd", "alt"},
     system = {"cmd", "alt", "ctrl"},
     screen = {"ctrl", "alt"}
   }
   ```

### 3. Clean Up Configuration (Priority: Medium)
1. Remove redundant files:
   - Merge move_workspace.lua into windows.lua
   - Remove custom clipboard implementation
   - Simplify wallpaper functionality

2. Organize remaining files:
   ```
   hammerspoon/
   ├── init.lua           # Main configuration
   ├── windows.lua        # All window management
   ├── apps.lua          # Application shortcuts
   ├── system.lua        # System operations
   ├── Spoons/           # Extensions
   └── config/           # Configuration files
   ```

### 4. Improve Spoon Integration (Priority: Medium)
1. ClipboardTool:
   - Remove custom clipboard code
   - Configure proper settings
   - Add clear keybinding

2. KSheet:
   - Fix display issues
   - Improve categorization
   - Add custom shortcuts properly

### 5. Documentation (Priority: Low)
1. Update README.md:
   - Clear installation instructions
   - Complete shortcut reference
   - Configuration options
   - Troubleshooting guide

2. Add inline documentation:
   - Function descriptions
   - Configuration options
   - Usage examples

## Implementation Order

1. **Phase 1: Window Management**
   - Create new windows.lua
   - Remove grid.lua
   - Update init.lua
   - Test all window operations

2. **Phase 2: Shortcut Cleanup**
   - Remove custom shortcuts display
   - Fix KSheet
   - Standardize modifier keys
   - Test all shortcuts

3. **Phase 3: Configuration Cleanup**
   - Remove redundant files
   - Organize remaining files
   - Update init.lua loading

4. **Phase 4: Spoon Enhancement**
   - Fix ClipboardTool
   - Enhance KSheet
   - Test all Spoon functionality

5. **Phase 5: Documentation**
   - Update README
   - Add inline documentation
   - Create usage guide

## Testing Checklist

- [ ] Window management operations
- [ ] Screen movement
- [ ] Application shortcuts
- [ ] System operations
- [ ] Clipboard functionality
- [ ] Shortcut display
- [ ] Window snapping
- [ ] Multi-screen support

## Core Configuration Files

### init.lua
The main configuration file that loads and initializes all other modules. This file:
- Sets up the configuration
- Loads required modules
- Initializes Spoons
- Sets global settings

### grid.lua
Window management functionality:
- Uses Cmd + Alt as modifier keys
- Basic window movement (left, right, up, down half-screen)
- Window maximize/restore functionality
- Screen management
- Currently simplified without grid functionality

### shortcuts.lua
Keyboard shortcut definitions and management:
- Global keyboard shortcuts
- Application-specific shortcuts
- Custom key bindings
- Shortcut visualization

### hotkeys.lua
Additional hotkey configurations:
- System-wide hotkeys
- Custom key combinations
- Modal key bindings
- Application launchers

### wallpaper.lua
Wallpaper management functionality:
- Wallpaper switching
- Directory monitoring
- Image handling
- Display management

### clipboard.lua
Clipboard management features:
- Clipboard history
- Text manipulation
- Paste actions
- Integration with ClipboardTool Spoon

### move_workspace.lua
Workspace management:
- Workspace switching
- Window organization
- Space management
- Multi-display support

### apps.lua
Application management:
- App launching shortcuts
- App focusing
- App window management
- Quick app switching

### cycle_windows.lua
Window cycling functionality:
- Window switching
- Focus management
- Window ordering
- Cycle through applications

## Spoons (Extensions)

### ClipboardTool.spoon
Advanced clipboard management:
- Clipboard history
- Formatted text support
- Image clipboard support
- Persistent storage

### KSheet.spoon
Keyboard shortcut cheat sheet:
- Shortcut visualization
- Application-specific shortcuts
- Custom shortcut documentation
- Quick reference display

## Additional Files

### .choices
User preferences and choices:
- Saved settings
- User configurations
- Custom preferences

### README.md
Documentation and setup instructions:
- Installation guide
- Configuration options
- Usage instructions
- Troubleshooting

## Current Issues and Areas for Improvement

1. Window Management
   - Conflicting shortcuts
   - Inconsistent behavior
   - Need to streamline grid vs. simple window management

2. Keyboard Shortcuts
   - Overlapping commands
   - Unclear documentation
   - Need better organization

3. Spoons Integration
   - KSheet display issues
   - ClipboardTool configuration
   - Better integration needed

4. Configuration Structure
   - Multiple files with overlapping functionality
   - Need better separation of concerns
   - More consistent naming conventions needed

## Next Steps

1. Consolidate window management functions
2. Resolve shortcut conflicts
3. Improve documentation
4. Clean up unused functionality
5. Standardize configuration approach
6. Fix Spoon issues 
