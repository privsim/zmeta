-- Define window management modifier keys
local windowMash = {"cmd", "alt"}

hs.window.animationDuration = 0

function getWin()
    return hs.window.focusedWindow()
end

-- Define a table to store original window sizes
local originalWindowSizes = {}

-- Function to toggle maximize and restore window size
local function toggleMaximize()
    local win = getWin()
    if not win then return end

    local winId = win:id()

    if originalWindowSizes[winId] then
        -- Restore original size
        win:setFrame(originalWindowSizes[winId])
        originalWindowSizes[winId] = nil
    else
        -- Save original size and maximize window
        originalWindowSizes[winId] = win:frame()
        win:maximize()
    end
end

-- Bind the toggle maximize function to ⌘ + Enter
hs.hotkey.bind({"⌘"}, "Return", toggleMaximize)

-- Function to handle window movement and resizing
local function moveWindow(direction)
    local win = getWin()
    if not win then return end

    local screen = win:screen()
    local frame = screen:frame()
    local winFrame = win:frame()

    if direction == "left" then
        winFrame.x = frame.x
        winFrame.w = frame.w / 2
    elseif direction == "right" then
        winFrame.x = frame.x + (frame.w / 2)
        winFrame.w = frame.w / 2
    elseif direction == "up" then
        winFrame.y = frame.y
        winFrame.h = frame.h / 2
    elseif direction == "down" then
        winFrame.y = frame.y + (frame.h / 2)
        winFrame.h = frame.h / 2
    end

    win:setFrame(winFrame)
end

-- Window movement hotkeys
hs.hotkey.bind(windowMash, "left", function() moveWindow("left") end)
hs.hotkey.bind(windowMash, "right", function() moveWindow("right") end)
hs.hotkey.bind(windowMash, "up", function() moveWindow("up") end)
hs.hotkey.bind(windowMash, "down", function() moveWindow("down") end)

-- Move window to next screen
hs.hotkey.bind(windowMash, "/", function()
    local win = getWin()
    if win then
        win:moveToScreen(win:screen():next())
    end
end)

-- Maximize window
hs.hotkey.bind(windowMash, "space", function()
    local win = getWin()
    if win then win:maximize() end
end)

-- Minimize window
hs.hotkey.bind(windowMash, ".", function()
    local win = getWin()
    if win then win:minimize() end
end)
