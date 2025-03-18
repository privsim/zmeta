-- Define window management modifier keys
local windowMash = {"ctrl", "alt"}

hs.grid.setGrid('3x3')
hs.grid.setMargins("0,0")
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
        hs.grid.maximizeWindow(win)
    end
end

-- Bind the toggle maximize function to ⌘ + Enter
hs.hotkey.bind({"⌘"}, "Return", toggleMaximize)

-- Function to cycle window sizes
local function cycleWindowSize(direction)
    local win = getWin()
    if not win then return end

    local screen = win:screen()
    local screenFrame = screen:frame()
    local winFrame = win:frame()
    local newWidth, newHeight, newX, newY

    local sizes = {1/2, 1/3, 1/4, 3/4, 2/3}
    local currentSize = winFrame.w / screenFrame.w
    local nextSizeIndex = 1

    for i, size in ipairs(sizes) do
        if math.abs(currentSize - size) < 0.01 then
            nextSizeIndex = i % #sizes + 1
            break
        end
    end

    local nextSize = sizes[nextSizeIndex]

    if direction == "left" or direction == "right" then
        newWidth = screenFrame.w * nextSize
        newHeight = winFrame.h
        newY = winFrame.y

        if direction == "left" then
            newX = screenFrame.x
        else
            newX = screenFrame.x + screenFrame.w - newWidth
        end
    else
        newWidth = winFrame.w
        newHeight = screenFrame.h * nextSize
        newX = winFrame.x

        if direction == "up" then
            newY = screenFrame.y
        else
            newY = screenFrame.y + screenFrame.h - newHeight
        end
    end

    win:setFrame(hs.geometry.rect(newX, newY, newWidth, newHeight))
end

-- Window movement hotkeys with cycling sizes
hs.hotkey.bind(windowMash, "1", function() cycleWindowSize("left") end)
hs.hotkey.bind(windowMash, "2", function() cycleWindowSize("right") end)
hs.hotkey.bind(windowMash, "3", function() cycleWindowSize("up") end)
hs.hotkey.bind(windowMash, "4", function() cycleWindowSize("down") end)

-- Window resizing hotkeys
hs.hotkey.bind(windowMash, "i", function() hs.grid.resizeWindowShorter() end)
hs.hotkey.bind(windowMash, "k", function() hs.grid.resizeWindowTaller() end)
hs.hotkey.bind(windowMash, "j", function() hs.grid.resizeWindowThinner() end)
hs.hotkey.bind(windowMash, "l", function() hs.grid.resizeWindowWider() end)

-- Grid size hotkeys
hs.hotkey.bind(windowMash, "5", function() hs.grid.setGrid('2x2'); hs.alert.show('Grid set to 2x2'); end)
hs.hotkey.bind(windowMash, "6", function() hs.grid.setGrid('3x3'); hs.alert.show('Grid set to 3x3'); end)
hs.hotkey.bind(windowMash, "7", function() hs.grid.setGrid('4x4'); hs.alert.show('Grid set to 4x4'); end)

-- Move window to next screen
hs.hotkey.bind(windowMash, "/", function()
    local win = getWin()
    win:moveToScreen(win:screen():next())
end)

-- Snap window to grid
hs.hotkey.bind(windowMash, ",", function() hs.grid.snap(getWin()) end)

-- Maximize window
hs.hotkey.bind(windowMash, "space", function() hs.grid.maximizeWindow() end)

-- Minimize window
hs.hotkey.bind(windowMash, ".", function() hs.grid.set(getWin(), '0,0 1x1') end)

-- New functionalities: Control volume and media playback
hs.hotkey.bind(windowMash, "v", function() hs.execute("osascript -e 'set volume output muted false'") end)
hs.hotkey.bind(windowMash, "m", function() hs.execute("osascript -e 'set volume output muted true'") end)
hs.hotkey.bind(windowMash, "[", function() hs.execute("osascript -e 'tell application \"System Events\" to key code 123 using control down'") end)
hs.hotkey.bind(windowMash, "]", function() hs.execute("osascript -e 'tell application \"System Events\" to key code 124 using control down'") end)
