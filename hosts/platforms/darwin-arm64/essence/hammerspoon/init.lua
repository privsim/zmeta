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

-- Function to move the current window to the next screen in a specific direction
local function moveWindowToScreen(direction)
    local win = hs.window.focusedWindow()
    if not win then return end

    local screen = win:screen()
    local targetScreen

    if direction == "left" then
        targetScreen = screen:toWest()
    elseif direction == "right" then
        targetScreen = screen:toEast()
    elseif direction == "up" then
        targetScreen = screen:toNorth()
    elseif direction == "down" then
        targetScreen = screen:toSouth()
    end

    if targetScreen then
        win:moveToScreen(targetScreen, true, true)  -- Move to the target screen, keeping window position relative to the screen
        win:focus()
    else
        hs.alert.show("No screen available in that direction")
    end
end

-- Hotkey bindings for moving windows between screens
hs.hotkey.bind(screenMash, "h", function() moveWindowToScreen("left") end)
hs.hotkey.bind(screenMash, "l", function() moveWindowToScreen("right") end)
hs.hotkey.bind(screenMash, "k", function() moveWindowToScreen("up") end)
hs.hotkey.bind(screenMash, "j", function() moveWindowToScreen("down") end)

-- Reload Hammerspoon configuration
hs.hotkey.bind(launchMash, "r", function() hs.reload() end)
print("Bound hyper key + R to reload configuration")

-- Lock screen
hs.hotkey.bind(launchMash, "a", function() hs.caffeinate.lockScreen() end)
print("Bound hyper key + a to lock screen")

hs.alert.show("Hammerspoon config loaded")
print("Hammerspoon configuration loaded successfully")
