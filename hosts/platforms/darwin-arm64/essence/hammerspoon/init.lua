-- Define hyper keys
launchMash = {"⌘", "⌥", "⌃"}
windowMash = {"⌘", "⌥"}
screenMash = {"⌃", "⌥"}

print("Initializing Hammerspoon configuration")

-- Global override for ⌘ + Enter to toggle maximize window
local originalWindowSizes = {}

local function toggleMaximize()
    local win = hs.window.focusedWindow()
    if not win then return end

    local winId = win:id()

    if originalWindowSizes[winId] then
        -- Restore original size
        win:setFrame(originalWindowSizes[winId])
        originalWindowSizes[winId] = nil
    else
        -- Save original size and maximize window
        originalWindowSizes[winId] = win:frame()
        hs.grid.maximizeWindow(win)
    end
end

hs.hotkey.bind({"⌘"}, "Return", toggleMaximize)
print("Bound ⌘ + Enter to toggleMaximize")

-- Load external configuration files
print("Loading external configuration files")
require "apps"
require "grid"
require "clipboard"
require "cycle_windows"
require "move_workspace"

-- Initialize desktop canvas
local canvas = require "wallpaper"  -- file is still named wallpaper.lua
canvas.init()
print("Initialized desktop canvas")

-- Load KSheet Spoon
print("Loading KSheet")
hs.loadSpoon("KSheet")
spoon.KSheet:bindHotkeys({
    toggle = {{"ctrl", "alt", "cmd"}, "/"}
})

-- Enhance KSheet with custom hotkeys display
local hotkeys = require "hotkeys"
hotkeys.enhanceKSheet()
print("Enhanced KSheet with custom hotkeys display")

-- Load dedicated shortcuts display
local shortcuts = require "shortcuts"
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "h", function() shortcuts.toggle() end)
print("Loaded dedicated shortcuts display (Ctrl + Alt + Cmd + H)")

-- Load tasks viewer
local tasks = require "tasks"
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "t", function() tasks.toggle() end)
print("Loaded tasks viewer (Ctrl + Alt + Cmd + T)")

-- Load ClipboardTool Spoon
print("Loading ClipboardTool")
hs.loadSpoon("ClipboardTool")
spoon.ClipboardTool:bindHotkeys({
    toggle_clipboard = {{"ctrl", "alt", "cmd"}, "V"}
})
spoon.ClipboardTool.show_copied_alert = false
spoon.ClipboardTool.paste_on_select = true
spoon.ClipboardTool:start()
print("Bound ClipboardTool to ctrl + alt + cmd + V")

-- Load screen navigation module (handles multi-monitor setups)
local screenNav = require "screen_nav"
screenNav.bindKeys(screenMash)
print("Loaded screen navigation with ⌃⌥ + arrow keys")

-- Load ACTIVE.md viewer
local active_view = require "active_view"
hs.hotkey.bind(launchMash, ".", function() active_view.toggle() end)
print("Loaded ACTIVE.md viewer (⌘⌥⌃ + .)")

-- Load macro manager
local macro_manager = require "macros"
hs.hotkey.bind(launchMash, "m", function() macro_manager.showChooser() end)
hs.hotkey.bind({"ctrl", "alt", "cmd", "shift"}, "m", function() macro_manager.toggle() end)
print("Loaded macro manager (⌘⌥⌃+M chooser, ⌘⌥⌃⇧+M manager)")

-- Reload Hammerspoon configuration
hs.hotkey.bind(launchMash, "r", function() hs.reload() end)
print("Bound hyper key + R to reload configuration")

-- Lock screen
hs.hotkey.bind(launchMash, "a", function() hs.caffeinate.lockScreen() end)
print("Bound hyper key + a to lock screen")

hs.alert.show("Hammerspoon config loaded")
print("Hammerspoon configuration loaded successfully")
