local windowMash = {"cmd", "alt"}
local tileMash = {"cmd", "alt", "ctrl"}

hs.window.animationDuration = 0
hs.grid.setGrid('3x3')
hs.grid.setMargins("0,0")

local function getWin()
    return hs.window.focusedWindow()
end

local snapSizes = {1/2, 1/3, 2/3, 1/4, 3/4}
local snapState = {}
local originalWindowSizes = {}

local function winKey(win)
    return tostring(win:id())
end

-- ⌘⌥ + arrows: cycle window size anchored to edge, preserve perpendicular dimension
local function cycleWindowSize(direction)
    local win = getWin()
    if not win then return end

    local screen = win:screen()
    local screenFrame = screen:frame()
    local winFrame = win:frame()

    local horizontal = (direction == "left" or direction == "right")
    local currentSize = horizontal
        and (winFrame.w / screenFrame.w)
        or  (winFrame.h / screenFrame.h)

    local nextSizeIndex = 1
    for i, size in ipairs(snapSizes) do
        if math.abs(currentSize - size) < 0.01 then
            nextSizeIndex = i % #snapSizes + 1
            break
        end
    end

    local ratio = snapSizes[nextSizeIndex]

    if direction == "left" then
        win:setFrame(hs.geometry.rect(
            screenFrame.x, winFrame.y,
            screenFrame.w * ratio, winFrame.h
        ))
    elseif direction == "right" then
        local newW = screenFrame.w * ratio
        win:setFrame(hs.geometry.rect(
            screenFrame.x + screenFrame.w - newW, winFrame.y,
            newW, winFrame.h
        ))
    elseif direction == "up" then
        win:setFrame(hs.geometry.rect(
            winFrame.x, screenFrame.y,
            winFrame.w, screenFrame.h * ratio
        ))
    elseif direction == "down" then
        local newH = screenFrame.h * ratio
        win:setFrame(hs.geometry.rect(
            winFrame.x, screenFrame.y + screenFrame.h - newH,
            winFrame.w, newH
        ))
    end
end

-- ⌘⌥⌃ + arrows: nudge window by % of screen without resizing
-- Widescreen (>2:1 aspect) uses 20% horizontal steps, otherwise 33%
local function nudgeWindow(direction)
    local win = getWin()
    if not win then return end

    local sf = win:screen():frame()
    local wf = win:frame()
    local aspect = sf.w / sf.h
    local isWide = aspect > 2.0

    local hStep = sf.w * (isWide and 0.20 or 0.33)
    local vStep = sf.h * 0.33

    local newX, newY = wf.x, wf.y

    if direction == "left" then
        newX = math.max(sf.x, wf.x - hStep)
    elseif direction == "right" then
        newX = math.min(sf.x + sf.w - wf.w, wf.x + hStep)
    elseif direction == "up" then
        newY = math.max(sf.y, wf.y - vStep)
    elseif direction == "down" then
        newY = math.min(sf.y + sf.h - wf.h, wf.y + vStep)
    end

    win:setFrame(hs.geometry.rect(newX, newY, wf.w, wf.h))
end

-- NEW: Zone presets — ⌘⌥ + number places window in Nth column position
-- Repeat quickly to cycle through positions within that column layout
local zoneState = {}

local function zonePreset(columns)
    local win = getWin()
    if not win then return end

    local key = winKey(win)
    local sf = win:screen():frame()
    local now = hs.timer.secondsSinceEpoch()

    local state = zoneState[key]
    local pos = 0

    if state and state.columns == columns and (now - state.time) < 1.5 then
        pos = (state.pos + 1) % columns
    end

    zoneState[key] = { columns = columns, pos = pos, time = now }

    local colW = sf.w / columns
    if columns == 4 then
        local row = math.floor(pos / 2)
        local col = pos % 2
        win:setFrame(hs.geometry.rect(
            sf.x + col * (sf.w / 2),
            sf.y + row * (sf.h / 2),
            sf.w / 2,
            sf.h / 2
        ))
    else
        win:setFrame(hs.geometry.rect(
            sf.x + pos * colW,
            sf.y,
            colW,
            sf.h
        ))
    end
end

-- NEW: Multi-tile — ⌘⌥⌃ + number auto-arranges all visible windows on screen
local function tileWindows(columns)
    local focusedWin = getWin()
    if not focusedWin then return end

    local screen = focusedWin:screen()
    local sf = screen:frame()

    local wins = hs.fnutils.filter(screen:allWindows(), function(w)
        return w:isStandard() and w:isVisible() and not w:isMinimized()
    end)
    if #wins == 0 then return end

    table.sort(wins, function(a, b)
        local af, bf = a:frame(), b:frame()
        if math.abs(af.x - bf.x) > 20 then return af.x < bf.x end
        return af.y < bf.y
    end)

    local colW = sf.w / columns
    local rows = math.ceil(#wins / columns)

    for i, win in ipairs(wins) do
        local col = (i - 1) % columns
        local row = math.floor((i - 1) / columns)
        if #wins <= columns then
            win:setFrame(hs.geometry.rect(sf.x + col * colW, sf.y, colW, sf.h))
        else
            win:setFrame(hs.geometry.rect(
                sf.x + col * colW,
                sf.y + row * (sf.h / rows),
                colW,
                sf.h / rows
            ))
        end
    end

    focusedWin:focus()
    hs.alert.show(string.format("Tiled %d windows · %d cols", #wins, columns))
end

-- === Keybindings ===

-- Directional snap with size cycling (same as before)
hs.hotkey.bind(windowMash, "left",  function() cycleWindowSize("left") end)
hs.hotkey.bind(windowMash, "right", function() cycleWindowSize("right") end)
hs.hotkey.bind(windowMash, "up",    function() cycleWindowSize("up") end)
hs.hotkey.bind(windowMash, "down",  function() cycleWindowSize("down") end)

-- Grid resize (same as before)
hs.hotkey.bind(windowMash, "i", function() hs.grid.resizeWindowShorter() end)
hs.hotkey.bind(windowMash, "k", function() hs.grid.resizeWindowTaller() end)
hs.hotkey.bind(windowMash, "j", function() hs.grid.resizeWindowThinner() end)
hs.hotkey.bind(windowMash, "l", function() hs.grid.resizeWindowWider() end)

-- Snap / maximize / minimize (same as before)
hs.hotkey.bind(windowMash, ",",     function() hs.grid.snap(getWin()) end)
hs.hotkey.bind(windowMash, "space", function() hs.grid.maximizeWindow() end)
hs.hotkey.bind(windowMash, ".",     function() hs.grid.set(getWin(), '0,0 1x1') end)

-- CHANGED: ⌘⌥ + 2/3/4 = zone presets (was: set grid size)
-- Repeat quickly to cycle position: left → center → right (etc)
hs.hotkey.bind(windowMash, "2", function() zonePreset(2) end)
hs.hotkey.bind(windowMash, "3", function() zonePreset(3) end)
hs.hotkey.bind(windowMash, "4", function() zonePreset(4) end)

-- NEW: ⌘⌥⌃ + 2/3/4 = auto-tile all visible windows into columns
hs.hotkey.bind(tileMash, "2", function() tileWindows(2) end)
hs.hotkey.bind(tileMash, "3", function() tileWindows(3) end)
hs.hotkey.bind(tileMash, "4", function() tileWindows(4) end)

-- NEW: ⌘⌥⌃ + arrows = nudge window (20% on widescreen, 33% otherwise)
hs.hotkey.bind(tileMash, "left",  function() nudgeWindow("left") end)
hs.hotkey.bind(tileMash, "right", function() nudgeWindow("right") end)
hs.hotkey.bind(tileMash, "up",    function() nudgeWindow("up") end)
hs.hotkey.bind(tileMash, "down",  function() nudgeWindow("down") end)
